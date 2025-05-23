﻿--EncounterPRO Open Source Project
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

-- Drop Procedure [dbo].[jmj_process_CPT_Code_Updates]
Print 'Drop Procedure [dbo].[jmj_process_CPT_Code_Updates]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_process_CPT_Code_Updates]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_process_CPT_Code_Updates]
GO

-- Create Procedure [dbo].[jmj_process_CPT_Code_Updates]
Print 'Create Procedure [dbo].[jmj_process_CPT_Code_Updates]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_process_CPT_Code_Updates (
	@ps_CPT_code varchar(24) ,
	@ps_procedure_type varchar(12) = NULL ,
	@ps_procedure_category_id varchar(24) = NULL ,
	@ps_modifier varchar(2) = NULL ,
	@ps_other_modifiers varchar(12) = NULL ,
	@ps_units float(8) = NULL ,
	@ps_default_bill_flag char(1) = NULL ,
	@ps_new_procedure_desc varchar(80) = NULL ,
	@ps_long_description varchar(max) = NULL ,
	@ps_from_cpt varchar(12) = NULL ,
	@ps_from_desc varchar(80) = NULL ,
	@ps_vaccine_id varchar(24) = NULL ,
	@ps_bill_assessment_id varchar(24) = NULL ,
	@ps_well_encounter_flag char(1) = NULL ,
	@ps_from_assess_id varchar(24) = NULL ,
	@ps_procedure_id varchar(24) = NULL ,
	@ps_operation varchar(24)
)
	
AS

--
-- @ps_operation = Type of code Update
--       Operations are:	
--		New		This is a brand new code
--		Revise		This is an existing code but the description has been revised substantially
--		CodeChange	An existing code has been changed to this new code
--		CodeChangeRev	An existing code has been changed to this new code and the description has changed non-substantively
--		ReviseLimit	This is an existing code but the description has been revised non-substantially
--		ReviseCheck		This code is no longer assignable directly because the procedure definition has changed
--		Delete		This code has been discontinued
--		ReviseAssess	This is an existing code but the bill_assessment_id needs to be changed.
--
--
-- CodeChange
-- 1) Update cpt_code to new code
--
-- CodeChangeRev
-- 1) Update cpt_code to new code
-- 2) Update procedure descriptions
-- 3) Update observation descriptions
-- 4) Update long descriptions
--
--
-- Revise and ReviseLimit
-- 1) Update procedure descriptions
-- 2) Update observation descriptions
-- 3) Update long descriptions
--
-- New, Revise, and ReviseCheck codes
-- 1) Add new procedures
--
-- Delete codes
-- 1) Update all existing procedures by adding the suffix " (Deleted)"
-- 2) Similarly update descriptions of associated observations
--
-- ReviseCheck codes
-- 1) Update all existing procedures by adding the suffix " (Check code)"
-- 2) Similarly update descriptions of associated observations
--
-- ReviseAssess codes
-- 1) Add or update the bill_assessment_id 
--


-- Address possibility for improper null values

IF @ps_cpt_code IS NULL
	BEGIN
	RAISERROR ('cpt_code cannot be NULL',16,-1)
	RETURN -1
	END

IF @ps_new_procedure_desc IS NULL AND @ps_operation IN ('New','Revise','ReviseCheck','ReviseLimit','CodeChangeRev') 
	BEGIN
	RAISERROR ('New procedure desc cannot be NULL if the operation is "New," "Revise," "ReviseLimit," "CodeChangeRev" or "ReviseCheck"',16,-1)
	RETURN -1
	END


IF @ps_from_cpt IS NULL AND @ps_operation IN ('CodeChange','CodeChangeRev') 
	BEGIN
	RAISERROR ('from_cpt cannot be NULL if the operation is "CodeChange" or "CodeChangeRev"',16,-1)
	RETURN -1
	END

IF @ps_units IS NULL
AND @ps_operation IN ('New','Revise','ReviseCheck') 
 SET @ps_units = 1


IF @ps_procedure_type IS NULL
AND @ps_operation IN ('New','Revise','ReviseCheck') 
 SET @ps_procedure_type = 'TESTPERFORM'

IF @ps_procedure_category_id IS NULL
AND @ps_procedure_type = 'TESTPERFORM'
AND @ps_operation IN ('New','Revise','ReviseCheck') 
 SET @ps_procedure_type = 'OTHER'

IF @ps_procedure_type IS NOT NULL
AND @ps_procedure_type <> 'TESTPERFORM'
AND @ps_procedure_category_id IS NULL
AND @ps_operation IN ('New','Revise','ReviseCheck') 
 	BEGIN
	RAISERROR ('procedure_category_id cannot be NULL if the operation is "New,"Revise," or "ReviseCheck"',16,-1)
	RETURN -1
 	END

--Update cpt codes and perform procedures where operation is 'CodeChange'or 'CodeChangeRev'

IF @ps_operation IN ('CodeChange','CodeChangeRev')
  BEGIN
	IF @ps_from_cpt IS NOT NULL AND @ps_cpt_code IS NOT NULL
	BEGIN
		UPDATE c_Procedure
		SET cpt_code = @ps_cpt_code
		WHERE cpt_code = @ps_from_cpt

		UPDATE c_Procedure_Coding
		SET cpt_code = @ps_cpt_code
		WHERE cpt_code = @ps_from_cpt		
	END

		
	IF @ps_procedure_category_id IS NOT NULL AND @ps_procedure_type IS NOT NULL
	BEGIN
		UPDATE c_Procedure
		SET procedure_category_id = @ps_procedure_category_id
		WHERE cpt_code = @ps_from_cpt
		AND procedure_type = @ps_procedure_type
	END
  END	

--Update procedure description and long description and observation
--description where operation is Revise or ReviseLimit

IF @ps_operation IN ('Revise','ReviseLimit','CodeChangeRev') 
  BEGIN
	
	

	IF @ps_from_desc IS NOT NULL
		BEGIN
		UPDATE c_Procedure
		SET description = @ps_new_procedure_desc
		WHERE cpt_code = @ps_cpt_code
		AND description = @ps_from_desc
		END

	
	IF @ps_long_description IS NOT NULL
		BEGIN
		UPDATE c_Procedure
		SET long_description = @ps_long_description
		WHERE cpt_code = @ps_cpt_code
		END

IF @ps_new_procedure_desc IS NOT NULL AND @ps_new_procedure_desc LIKE '% : (%' AND @ps_from_desc IS NOT NULL
		BEGIN
		UPDATE o
		SET o.description = @ps_new_procedure_desc + ' (' + p.cpt_code + ')'
		FROM c_observation o INNER JOIN c_procedure p
		ON o.perform_procedure_id = p.procedure_id
			WHERE p.cpt_code = @ps_cpt_code
			AND o.observation_type = 'Perform Procedure'
		
			
		END	
	IF @ps_new_procedure_desc IS NOT NULL AND @ps_new_procedure_desc NOT LIKE '% : (%' AND @ps_from_desc IS NOT NULL
		BEGIN
		UPDATE o2
		SET o2.description = @ps_new_procedure_desc + ' : (' + p2.cpt_code + ')'
		FROM c_observation o2 INNER JOIN c_procedure p2
		ON o2.perform_procedure_id = p2.procedure_id
			WHERE p2.cpt_code = @ps_cpt_code
			AND o2.observation_type = 'Perform Procedure'
			
		END


  END



--This script adds new locally-owned procedure records where operation is New, Revise and ReviseCheck

DECLARE @ls_new_procedure_id varchar(24),
	@ls_deleted_suffix varchar(32),
	@ls_check_suffix varchar(32)
	
	
SET @ls_deleted_suffix = ' (Deleted)'
SET @ls_check_suffix = ' (Check code)'

IF @ps_operation IN ('New', 'Revise', 'ReviseCheck')

   BEGIN
	
	IF NOT EXISTS
	(SELECT * FROM c_procedure 	
	WHERE cpt_code = @ps_cpt_code
	AND description = @ps_new_procedure_desc
	AND status = 'OK')
	BEGIN	
	EXECUTE sp_new_procedure
		@ps_cpt_code = @ps_cpt_code ,
		@ps_procedure_type = @ps_procedure_type ,
		@ps_procedure_category_id = @ps_procedure_category_id ,
		@ps_description = @ps_new_procedure_desc ,
		@ps_long_description = @ps_long_description ,
		@pr_units = @ps_units ,
		@ps_modifier = @ps_modifier ,
		@ps_other_modifiers = @ps_other_modifiers ,
		@ps_default_bill_flag = @ps_default_bill_flag ,
		@ps_bill_assessment_id = @ps_bill_assessment_id ,
		@ps_well_encounter_flag = @ps_well_encounter_flag

	END
   END

-- This script adds a suffix to the procedure description and 
-- the associated observation description if the operation is 'Delete.'
-- This script also deletes records from c_procedure_coding if the cpt_code
-- has been deleted.

IF @ps_operation IN ('Delete')
  BEGIN
	UPDATE c_Procedure
	SET description = LEFT(description, 80 - LEN(@ls_deleted_suffix)) + @ls_deleted_suffix
	WHERE cpt_code = @ps_cpt_code
	AND RIGHT(description, LEN(@ls_deleted_suffix)) <> @ls_deleted_suffix

	UPDATE o
	SET o.description = LEFT(o.description, 80 - LEN(@ls_deleted_suffix)) + @ls_deleted_suffix
	FROM c_observation o INNER JOIN c_procedure p
	ON o.perform_procedure_id = p.procedure_id
	WHERE p.cpt_code = @ps_cpt_code
	AND RIGHT(o.description, LEN(@ls_deleted_suffix)) <> @ls_deleted_suffix

	DELETE c
	FROM c_procedure_coding c
	WHERE c.cpt_code = @ps_cpt_code


  END


--This script adds a suffix to the procedure description and 
--the associated observation description if the operation is ReviseCheck


IF @ps_operation IN ('ReviseCheck')
  BEGIN

	UPDATE c_Procedure
	SET description = LEFT(description, 80 - LEN(@ls_check_suffix)) + @ls_check_suffix 
	WHERE cpt_code = @ps_cpt_code
	AND COALESCE (modifier,'NA') = COALESCE (@ps_modifier,'NA')
	AND COALESCE (other_modifiers,'NA') = COALESCE (@ps_other_modifiers,'NA')
	AND units = @ps_units
	AND default_bill_flag = @ps_default_bill_flag
	AND description <> @ps_new_procedure_desc
	AND description IS NOT NULL
	AND RIGHT(description, LEN(@ls_check_suffix)) <> @ls_check_suffix

  END

IF @ps_operation IN ('ReviseCheck')
  BEGIN

	UPDATE o
	SET o.description = LEFT(o.description, 80 - LEN(@ls_check_suffix)) + @ls_check_suffix 
	FROM c_observation o INNER JOIN c_procedure p
	ON o.perform_procedure_id = p.procedure_id
	WHERE p.cpt_code = @ps_cpt_code
	AND COALESCE (modifier,'NA') = COALESCE (@ps_modifier,'NA')
	AND COALESCE (other_modifiers,'NA') = COALESCE (@ps_other_modifiers,'NA')
	AND p.units = @ps_units
	AND p.default_bill_flag = @ps_default_bill_flag
	AND p.description <> @ps_new_procedure_desc
	AND p.description IS NOT NULL
	AND RIGHT(o.description, LEN(@ls_check_suffix)) <> @ls_check_suffix

  END



-- This script updates bill_assessment_ids

IF @ps_operation IN ('ReviseAssess')
  BEGIN

	If @ps_vaccine_id IS NOT NULL AND @ps_from_assess_id IS NOT NULL
	BEGIN
		UPDATE c_Procedure
		SET bill_assessment_id = @ps_bill_assessment_id 
		WHERE cpt_code = @ps_cpt_code
		AND procedure_type = @ps_procedure_type
		AND vaccine_id = @ps_vaccine_id
		AND bill_assessment_id = @ps_from_assess_id
	END

If @ps_vaccine_id IS NOT NULL AND @ps_from_assess_id IS NULL
	BEGIN
		UPDATE c_Procedure
		SET bill_assessment_id = @ps_bill_assessment_id 
		WHERE cpt_code = @ps_cpt_code
		AND procedure_type = @ps_procedure_type
		AND vaccine_id = @ps_vaccine_id
	END

If @ps_vaccine_id IS NULL AND @ps_from_assess_id IS NOT NULL
	BEGIN
		UPDATE c_Procedure
		SET bill_assessment_id = @ps_bill_assessment_id 
		WHERE cpt_code = @ps_cpt_code
		AND procedure_type = @ps_procedure_type
		AND bill_assessment_id = @ps_from_assess_id
	END

	If @ps_vaccine_id IS NULL AND @ps_from_assess_id IS NULL
	BEGIN
		UPDATE c_Procedure
		SET bill_assessment_id = @ps_bill_assessment_id 
		WHERE cpt_code = @ps_cpt_code
		AND procedure_type = @ps_procedure_type
	END

  END
GO

