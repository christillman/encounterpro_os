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

-- Drop Procedure [dbo].[sp_reconcile_treatment_status]
Print 'Drop Procedure [dbo].[sp_reconcile_treatment_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_reconcile_treatment_status]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_reconcile_treatment_status]
GO

-- Create Procedure [dbo].[sp_reconcile_treatment_status]
Print 'Create Procedure [dbo].[sp_reconcile_treatment_status]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.sp_reconcile_treatment_status    Script Date: 7/25/2000 8:44:04 AM ******/
CREATE PROCEDURE sp_reconcile_treatment_status
AS
-- This procedure recalculates the p_Treatment_Item.treatment_status field.
-- It is important that each site in a multi-site organization calculate
-- the same value, even if they don't share the same primary key values.
-- Therefore, we will get the close record with the latest date_time.
-- It is unlikely but possible that two close records have the same date_time
-- We will handle this by selecting the highest user_id from any records which -- tie on the date_time.
-- Create temp table to hold progress records created at the same time
CREATE TABLE #tmp_tr_prg_dups (
	cpr_id varchar(12),
	treatment_id int,
	treatment_progress_sequence int,
	created datetime,
	progress_date_time datetime,
	user_id varchar(24),
	dup_sequence int IDENTITY (1,1))
-- First get all the close progress records, with complete alternate keys
SELECT cpr_id, treatment_id, max(created) as created, count(*) as progress_count
INTO #tmp_tr_progress1
FROM p_Treatment_Progress
WHERE progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
GROUP BY cpr_id, treatment_id
-- Now get the progress records where there is only one progress record
SELECT a.cpr_id, a.treatment_id, a.progress_type as treatment_status, a.progress_date_time as end_date, a.encounter_id
INTO #tmp_tr_progress_upd
FROM p_Treatment_Progress a, #tmp_tr_progress1 b
WHERE a.cpr_id = b.cpr_id
AND a.treatment_id = b.treatment_id
AND a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
AND b.progress_count = 1
-- Now isolate the latest progress records from the treatments which have more than one progress record
INSERT INTO  #tmp_tr_prg_dups (
	cpr_id ,
	treatment_id,
	treatment_progress_sequence,
	created ,
	progress_date_time ,
	user_id )
SELECT	b.cpr_id,
		b.treatment_id,
		b.treatment_progress_sequence,
		b.created,
		b.progress_date_time,
		b.user_id
FROM #tmp_tr_progress1 a, p_Treatment_Progress b
WHERE a.progress_count > 1
AND a.cpr_id = b.cpr_id
AND a.treatment_id = b.treatment_id
AND a.created = b.created
AND b.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
ORDER BY b.cpr_id, b.treatment_id, b.progress_date_time desc, b.user_id
-- Get only one progress record for each treatment from ordered list created above
SELECT cpr_id, treatment_id, min(dup_sequence) as dup_sequence
INTO #tmp_tr_nodups
FROM #tmp_tr_prg_dups
GROUP BY cpr_id, treatment_id
-- Now add the isolated progress records to the existing list
INSERT INTO #tmp_tr_progress_upd (
	cpr_id,
	treatment_id,
	treatment_status,
	end_date,
	encounter_id)	
SELECT a.cpr_id,
	a.treatment_id,
	a.progress_type as treatment_status,
	a.progress_date_time as end_date,
	a.encounter_id
FROM p_Treatment_Progress a,
	#tmp_tr_prg_dups b,
	#tmp_tr_nodups c
WHERE a.cpr_id = b.cpr_id
AND a.treatment_id = b.treatment_id
AND a.cpr_id = c.cpr_id
AND a.treatment_id = c.treatment_id
AND a.progress_type in ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
AND a.treatment_progress_sequence = b.treatment_progress_sequence
AND b.dup_sequence = c.dup_sequence
-- Now update p_Treatment_Item
UPDATE p_Treatment_Item
SET	treatment_status = NULL,
	end_date = NULL,
	close_encounter_id = NULL
UPDATE p_Treatment_Item
SET	treatment_status = t.treatment_status,
	end_date = t.end_date,
	close_encounter_id = t.encounter_id
FROM #tmp_tr_progress_upd t
WHERE p_Treatment_Item.cpr_id = t.cpr_id
AND p_Treatment_Item.treatment_id = t.treatment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_reconcile_treatment_status]
	TO [cprsystem]
GO

