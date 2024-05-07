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

-- Drop Procedure [dbo].[sp_add_property_results_to_treatment_type]
Print 'Drop Procedure [dbo].[sp_add_property_results_to_treatment_type]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_add_property_results_to_treatment_type]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_property_results_to_treatment_type]
GO

-- Create Procedure [dbo].[sp_add_property_results_to_treatment_type]
Print 'Create Procedure [dbo].[sp_add_property_results_to_treatment_type]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_add_property_results_to_treatment_type
	(
	@ps_treatment_type varchar(24),
	@ps_result varchar(80)
	)
AS


DECLARE @ll_property_id int

DECLARE @result_sequence TABLE (
	observation_id varchar(24),
	result_sequence smallint)

SELECT @ll_property_id = property_id
FROM c_Property
WHERE property_object = 'Treatment'
AND function_name = @ps_result

IF @@ROWCOUNT <> 1
	BEGIN
	INSERT INTO c_Property (
		property_type,
		property_object,
		description,
		function_name,
		status )
	VALUES (
		'User Defined',
		'Treatment',
		@ps_result,
		@ps_result,
		'OK' )

	SET @ll_property_id = @@IDENTITY
	END

INSERT INTO @result_sequence (
	observation_id ,
	result_sequence)
SELECT t.observation_id,
	CASE WHEN max(r.result_sequence) IS NULL THEN 1 ELSE max(r.result_sequence) + 1 END as result_sequence
FROM c_Observation_Treatment_Type t
	LEFT OUTER JOIN c_Observation_Result r
	ON r.observation_id = t.observation_id
WHERE t.treatment_type = @ps_treatment_type
AND NOT EXISTS (
	SELECT observation_id
	FROM c_Observation_Result r2
	WHERE t.observation_id = r2.observation_id
	AND r2.result_type = 'PROPERTY'
	AND r2.result = @ps_result )
AND (NOT EXISTS (
		SELECT tree.child_observation_id
		FROM c_Observation_Tree tree
		WHERE t.observation_id = tree.child_observation_id )
	OR EXISTS (
		SELECT item_id
		FROM u_top_20
		WHERE t.observation_id = u_top_20.item_id ) )
GROUP BY t.observation_id

-- Add the property result
INSERT INTO c_Observation_Result (
	[observation_id] ,
	[result_sequence] ,
	[result_type] ,
	[result_unit] ,
	[result] ,
	[result_amount_flag] ,
	[print_result_flag] ,
	[severity] ,
	[abnormal_flag] ,
	[property_id] ,
	[service] ,
	[print_result_separator] ,
	[status] ,
	[last_updated] ,
	[updated_by] )
SELECT [observation_id] ,
	[result_sequence] ,
	'PROPERTY' ,
	NULL ,
	@ps_result ,
	'N' ,
	'Y' ,
	0 ,
	'N' ,
	@ll_property_id ,
	'REFER_TREATMENT' ,
	'=' ,
	'OK' ,
	dbo.get_client_datetime() ,
	'#SYSTEM'
FROM @result_sequence

-- Fix any orphans
UPDATE c_Observation_Result
SET property_id = @ll_property_id
WHERE result_type = 'PROPERTY'
AND result = @ps_result
AND property_id IS NOT NULL
AND NOT EXISTS (
	SELECT property_id
	FROM c_Property
	WHERE c_Property.property_id = c_Observation_Result.property_id)


GO
GRANT EXECUTE
	ON [dbo].[sp_add_property_results_to_treatment_type]
	TO [cprsystem]
GO

