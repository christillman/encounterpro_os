--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_office_productivity]
Print 'Drop Function [dbo].[fn_office_productivity]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_office_productivity]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_office_productivity]
GO

-- Create Function [dbo].[fn_office_productivity]
Print 'Create Function [dbo].[fn_office_productivity]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_office_productivity (
	@ps_office_id varchar(4) = NULL,
	@pdt_begin_date datetime = NULL,
	@pdt_end_date datetime = NULL,
	@ps_indirect_flag char(1) = 'D'
	)

RETURNS @productivity TABLE (
	provider varchar(24) NOT NULL,
	total_encounters int NULL,
	total_level_encounters int NULL,
	total_days int NULL,
	level_1_encounters int NULL,
	level_2_encounters int NULL,
	level_3_encounters int NULL,
	level_4_encounters int NULL,
	level_5_encounters int NULL,
	avg_enc_time decimal(9,1) NULL,
	avg_wait_time decimal(9,1) NULL)


AS

BEGIN


-- If the end_date is not supplied, then assume a range of one day
-- specified by the begin_date
IF @pdt_end_date IS NULL
	SET @pdt_end_date = @pdt_begin_date

-- Always get whole days
SET @pdt_end_date = convert(datetime, convert(varchar(10),@pdt_end_date, 101) + ' 23:59:59.999')
SET @pdt_begin_date = convert(datetime, convert(varchar(10),@pdt_begin_date, 101))

IF @ps_office_id = ''
	SET @ps_office_id = NULL

DECLARE @encounters TABLE (
	provider varchar(24) NOT NULL,
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	patient_workplan_id int NULL,
	day int NULL,
	visit_level int NULL,
	encounter_type varchar(24) NULL,
	encounter_date datetime NULL,
	discharge_date datetime NULL,
	wait_start_time datetime NULL,
	wait_end_time datetime NULL)

DECLARE @levels TABLE (
	provider varchar(24) NOT NULL,
	visit_level int NULL,
	encounter_count int NULL)

INSERT INTO @encounters (
	provider ,
	cpr_id ,
	encounter_id ,
	patient_workplan_id ,
	day ,
	encounter_type ,
	encounter_date ,
	discharge_date )
SELECT e.attending_doctor,
		e.cpr_id,
		e.encounter_id,
		e.patient_workplan_id,
		DATEDIFF(day, @pdt_begin_date, e.encounter_date) + 1,
		e.encounter_type,
		e.encounter_date,
		e.discharge_date
FROM p_Patient_Encounter e
WHERE e.encounter_date >= @pdt_begin_date
AND e.encounter_date <= @pdt_end_date
AND (@ps_office_id IS NULL OR e.office_id = @ps_office_id)
AND e.encounter_status = 'CLOSED'
AND e.attending_doctor IS NOT NULL
AND e.indirect_flag = @ps_indirect_flag


UPDATE e
SET visit_level = CAST(progress_value AS int)
FROM @encounters e
	INNER JOIN p_Patient_Encounter_Progress p
	ON e.cpr_id = p.cpr_id
	AND e.encounter_id = p.encounter_id
WHERE p.progress_type = 'PROPERTY'
AND p.progress_key = 'EM_ENCOUNTER_LEVEL'
AND p.current_flag ='Y'
AND ISNUMERIC(progress_value) = 1

-- Consider any waiting time over 4 hours to be bad data
UPDATE e
SET wait_start_time = i.dispatch_date,
	wait_end_time = i.end_date
FROM @encounters e
	INNER JOIN p_Patient_WP_Item i
	ON e.patient_workplan_id = i.patient_workplan_id
WHERE i.item_type = 'Service'
AND i.ordered_service = 'GET_PATIENT'
AND i.status = 'Completed'
AND DATEDIFF(hour, i.dispatch_date, i.end_date) <= 4

INSERT INTO @levels (
	provider,
	visit_level,
	encounter_count)
SELECT provider,
	visit_level,
	count(*) as encounter_count
FROM @encounters
WHERE visit_level IS NOT NULL
GROUP BY provider,
	visit_level


INSERT INTO @productivity  (
	provider ,
	total_encounters ,
	total_days )
SELECT provider,
	COUNT(*),
	COUNT(DISTINCT day)
FROM @encounters
GROUP BY provider

-- Consider any encounter time over 4 hours to be bad data
UPDATE p
SET avg_enc_time = x.avg_enc_time
FROM @productivity p
	INNER JOIN (SELECT provider, AVG(CAST(DATEDIFF(second, encounter_date, discharge_date) AS decimal(9,1))) / 60 as avg_enc_time
				FROM @encounters
				WHERE discharge_date IS NOT NULL
				AND DATEDIFF(hour, encounter_date, discharge_date) <= 4
				AND encounter_date < discharge_date
				GROUP BY provider) x
	ON p.provider = x.provider

-- Consider any encounter time over 4 hours to be bad data
UPDATE p
SET avg_wait_time = x.avg_wait_time
FROM @productivity p
	INNER JOIN (SELECT provider, AVG(CAST(DATEDIFF(second, wait_start_time, wait_end_time) AS decimal(9,1))) / 60 as avg_wait_time
				FROM @encounters
				WHERE wait_end_time IS NOT NULL
				AND DATEDIFF(hour, wait_start_time, wait_end_time) <= 4
				AND wait_start_time < wait_end_time
				GROUP BY provider) x
	ON p.provider = x.provider

UPDATE p
SET total_level_encounters = x.total_level_encounters
FROM @productivity p
	INNER JOIN (SELECT provider, count(*) as total_level_encounters
				FROM @encounters
				WHERE visit_level IS NOT NULL
				GROUP BY provider) x
	ON p.provider = x.provider

UPDATE p
SET level_1_encounters = l.encounter_count
FROM @productivity p
	INNER JOIN @levels l
	ON p.provider = l.provider
WHERE l.visit_level = 1

UPDATE p
SET level_2_encounters = l.encounter_count
FROM @productivity p
	INNER JOIN @levels l
	ON p.provider = l.provider
WHERE l.visit_level = 2

UPDATE p
SET level_3_encounters = l.encounter_count
FROM @productivity p
	INNER JOIN @levels l
	ON p.provider = l.provider
WHERE l.visit_level = 3

UPDATE p
SET level_4_encounters = l.encounter_count
FROM @productivity p
	INNER JOIN @levels l
	ON p.provider = l.provider
WHERE l.visit_level = 4

UPDATE p
SET level_5_encounters = l.encounter_count
FROM @productivity p
	INNER JOIN @levels l
	ON p.provider = l.provider
WHERE l.visit_level = 5



RETURN
END

GO
GRANT SELECT ON [dbo].[fn_office_productivity] TO [cprsystem]
GO

