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

-- Drop Function [dbo].[fn_config_image_vaccine_schedule]
Print 'Drop Function [dbo].[fn_config_image_vaccine_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_config_image_vaccine_schedule]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_config_image_vaccine_schedule]
GO

-- Create Function [dbo].[fn_config_image_vaccine_schedule]
Print 'Create Function [dbo].[fn_config_image_vaccine_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_config_image_vaccine_schedule (
	)
RETURNS xml

AS
BEGIN

DECLARE @lx_xml xml

DECLARE @Age_Ranges TABLE (
	age_range_id int NOT NULL,
	age_range_category varchar(24) NOT NULL,
	description varchar(40) NULL,
	age_from int NULL,
	age_from_unit varchar(24) NULL,
	age_to int NULL,
	age_to_unit varchar(24) NULL
	)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Disease_Group d
	ON a.age_range_id = d.age_range

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.patient_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.first_dose_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)

INSERT INTO @Age_Ranges (
	age_range_id ,
	age_range_category ,
	description ,
	age_from ,
	age_from_unit ,
	age_to ,
	age_to_unit )
SELECT a.age_range_id ,
	a.age_range_category ,
	a.description ,
	a.age_from ,
	a.age_from_unit ,
	a.age_to ,
	a.age_to_unit
FROM c_Age_Range a
	INNER JOIN c_Immunization_Dose_Schedule d
	ON a.age_range_id = d.last_dose_age_range_id
WHERE NOT EXISTS (
	SELECT 1
	FROM @Age_Ranges x
	WHERE x.age_range_id = a.age_range_id)
	

SET @lx_xml = CONVERT(xml, '<VaccineSchedule>
' + (SELECT disease_group
		  ,description
		  ,sort_sequence
		  ,status
		  ,age_range
		  ,sex
		  ,id
		  ,last_updated
		  ,owner_id
	FROM c_Disease_Group
	FOR XML RAW ('DiseaseGroup'))
+ '
' + (SELECT disease_group
		  ,disease_id
		  ,sort_sequence
		  ,id
		  ,last_updated
		  ,owner_id
	FROM c_Disease_Group_Item
	FOR XML RAW ('DiseaseGroupItem'))
+ '
' + (SELECT disease_id
		  ,dose_schedule_sequence
		  ,dose_number
		  ,patient_age_range_id
		  ,first_dose_age_range_id
		  ,last_dose_age_range_id
		  ,last_dose_interval_amount
		  ,last_dose_interval_unit_id
		  ,sort_sequence
		  ,dose_text
	FROM c_Immunization_Dose_Schedule
	FOR XML RAW ('DoseSchedule'))
+ '
' + (SELECT age_range_id
			,age_range_category
			,description
			,age_from
			,age_from_unit
			,age_to
			,age_to_unit
	FROM @age_ranges
	FOR XML RAW ('AgeRange'))
+ '
</VaccineSchedule>')


RETURN @lx_xml

END


GO
GRANT EXECUTE
	ON [dbo].[fn_config_image_vaccine_schedule]
	TO [cprsystem]
GO

