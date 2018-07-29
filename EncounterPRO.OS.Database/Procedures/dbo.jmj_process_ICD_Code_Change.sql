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

-- Drop Procedure [dbo].[jmj_process_ICD_Code_Change]
Print 'Drop Procedure [dbo].[jmj_process_ICD_Code_Change]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_process_ICD_Code_Change]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_process_ICD_Code_Change]
GO

-- Create Procedure [dbo].[jmj_process_ICD_Code_Change]
Print 'Create Procedure [dbo].[jmj_process_ICD_Code_Change]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_process_ICD_Code_Change
	@ps_icd10_code varchar(12),
	@ps_description varchar(80),
	@ps_from_description varchar(80) = NULL,
	@ps_assessment_type varchar(24) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_long_description text = NULL,
	@ps_operation varchar(24),
	@ps_from_icd10_code varchar(12) = NULL
AS

--
-- @ps_operation = Type of code change
--       Options are:	New			This is a brand new code
--						Revise		This is an existing code but the description has been revised
--						CodeChange	An existing code has been changed to this new code
--						Delete		This code has been discontinued
--						Replaced	This code has been replaced by more detailed codes.  This code
--									is no longer assignable directly
--
-- New and Revised codes
-- 1) Add new assessment
-- 2) If new assessment does not have a treatment list then ...
--   2a) Find all assessments with the same ICD code which have a treatment list
--   2b) If none found and ICD has 5 digits, then find all assessments with the same 1st 4 digits of the ICD code which have a treatment list
--   2c) if any assessments found in 2a or 2b, then determine which assessment was most recently used.  If none have ever been used then
--       find which assessment was most recently created.
--   2d) Copy the treatment list from the assessment found in 2c to the new assessment
--
--
-- Deleted codes
-- 1) Update all existing assessments by adding the suffix " (deleted)"
--

IF @ps_icd10_code IS NULL
	BEGIN
	RAISERROR ('icd10_code cannot be NULL',16,-1)
	RETURN -1
	END

IF @ps_description IS NULL AND @ps_operation <> 'Replaced'
	BEGIN
	RAISERROR ('Description cannot be NULL unless the operation is "Replaced"',16,-1)
	RETURN -1
	END

IF @ps_assessment_category_id IS NULL
 SET @ps_assessment_category_id = 'AANEW'

DECLARE @ls_new_assessment_id varchar(24),
	@ls_existing_assessment_id varchar(24),
	@ls_deleted_suffix varchar(32),
	@ls_replaced_suffix varchar(32),
	@ll_count int,
	@ls_assessment_type varchar(24)

DECLARE @assessments TABLE (
	assessment_id varchar(24) NOT NULL,
	treatment_count int NULL,
	last_used datetime NULL)

SET @ls_deleted_suffix = ' (Deleted)'
SET @ls_replaced_suffix = ' (Replaced - Use detailed code)'

IF @ps_operation IN ('New', 'Revise')
	BEGIN
	IF @ps_assessment_type IS NULL
		BEGIN
		IF LEFT(@ps_icd10_code, 2) = 'V2'
			SET @ls_assessment_type = 'WELL'
		ELSE
			SET @ls_assessment_type = 'SICK'
		END
	ELSE
		SET @ls_assessment_type = @ps_assessment_type
	
	-- If the description is supposed to be updated, then do it now
	IF @ps_operation = 'Revise' AND @ps_from_description IS NOT NULL
		BEGIN
		UPDATE c_Assessment_Definition
		SET description = @ps_description
		WHERE icd10_code = COALESCE(@ps_from_icd10_code, @ps_icd10_code)
		AND description = @ps_from_description
		END
		
	EXECUTE sp_new_assessment
		@ps_assessment_type = @ls_assessment_type,
		@ps_icd10_code = @ps_icd10_code,
		@ps_assessment_category_id = @ps_assessment_category_id,
		@ps_description = @ps_description,
		@ps_long_description = @ps_long_description,
		@ps_assessment_id = @ls_new_assessment_id OUTPUT

	IF @ls_new_assessment_id IS NOT NULL
		BEGIN
		SELECT @ll_count = count(*)
		FROM u_Assessment_Treat_Definition
		WHERE assessment_id = @ls_new_assessment_id
		
		IF @ll_count = 0
			BEGIN
			IF @ps_from_icd10_code IS NOT NULL
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = @ps_from_icd10_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = @ps_icd10_code
				GROUP BY u.assessment_id
				END
			
			IF (SELECT COUNT(*) FROM @assessments) = 0 AND LEN(@ps_icd10_code) = 6 -- 5 digits plus the decimal point
				BEGIN
				INSERT INTO @assessments (
					assessment_id,
					treatment_count)
				SELECT u.assessment_id, count(*)
				FROM u_Assessment_Treat_Definition u
					INNER JOIN c_Assessment_Definition a
					ON u.assessment_id = a.assessment_id
				WHERE a.icd10_code = LEFT(@ps_icd10_code, 5)
				GROUP BY u.assessment_id
				END
				
			-- If we found any assessments, then determine the latest one used
			IF (SELECT COUNT(*) FROM @assessments) > 0
				BEGIN
				UPDATE a
				SET last_used = x.last_used
				FROM @assessments a
					INNER JOIN (SELECT assessment_id, max(created) as last_used
								FROM p_Assessment
								GROUP BY assessment_id) x
					ON a.assessment_id = x.assessment_id
				
				SELECT TOP 1 @ls_existing_assessment_id = assessment_id
				FROM @assessments
				ORDER BY last_used desc
				
				EXECUTE jmj_copy_assessment_treatment_lists
					@ps_From_assessment_id = @ls_existing_assessment_id,
					@ps_To_assessment_id = @ls_new_assessment_id,
					@ps_Action = 'Ignore' -- Don't copy if there are already treatment list items for the new assesment				
				
				END
			
			END
		END
	END

IF @ps_operation IN ('CodeChange')
	BEGIN
	IF @ps_from_icd10_code IS NOT NULL AND @ps_icd10_code IS NOT NULL
		UPDATE c_Assessment_Definition
		SET icd10_code = @ps_icd10_code
		WHERE icd10_code = @ps_from_icd10_code
		AND (description = @ps_description OR definition = @ps_description)
	END

IF @ps_operation IN ('Delete')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_deleted_suffix)) + @ls_deleted_suffix
	WHERE icd10_code = @ps_icd10_code
	AND (description = @ps_description OR definition = @ps_description)
	AND RIGHT(description, LEN(@ls_deleted_suffix)) <> @ls_deleted_suffix

	END

IF @ps_operation IN ('Replaced')
	BEGIN
	UPDATE c_Assessment_Definition
	SET description = LEFT(description, 80 - LEN(@ls_replaced_suffix)) + @ls_replaced_suffix
	WHERE icd10_code = @ps_icd10_code
	AND RIGHT(description, LEN(@ls_replaced_suffix)) <> @ls_replaced_suffix

	END

GO
GRANT EXECUTE
	ON [dbo].[jmj_process_ICD_Code_Change]
	TO [cprsystem]
GO

