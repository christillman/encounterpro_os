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

-- Drop Procedure [dbo].[sp_new_assessment]
Print 'Drop Procedure [dbo].[sp_new_assessment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_assessment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_assessment]
GO

-- Create Procedure [dbo].[sp_new_assessment]
Print 'Create Procedure [dbo].[sp_new_assessment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_new_assessment (
	@ps_assessment_type varchar(24),
	@ps_icd10_code varchar(12) = NULL,
	@ps_assessment_category_id varchar(24) = NULL,
	@ps_description varchar(80),
	@ps_location_domain varchar(12) = NULL,
	@ps_auto_close char(1) = 'N',
	@pi_auto_close_interval_amount smallint = NULL,
	@ps_auto_close_interval_unit varchar(24) = NULL,
	@pl_risk_level integer = NULL,
	@pl_complexity integer = NULL,
	@ps_long_description text = NULL ,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL,
	@ps_assessment_id varchar(24) OUTPUT,
	@ps_allow_dup_icd10_code char(1) = 'Y' )
AS

DECLARE @ll_key_value integer ,
	@ls_assessment_id varchar(24) ,
	@ls_old_status varchar(12) ,
	@ll_rows int,
	@ll_count int,
	@ls_trimmed_description varchar(80),
	@ls_key varchar(20),
	@ll_key_suffix int,
	@ls_long_description_varchar varchar(4000)

IF @ps_description IS NULL OR @ps_description = ''
	BEGIN
	RAISERROR ('New assessment must have a description',16,-1)
	ROLLBACK TRANSACTION
	RETURN 0
	END

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_allow_dup_icd10_code IS NULL
	SET @ps_allow_dup_icd10_code = 'Y'

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

SET @ls_long_description_varchar = CAST(@ps_long_description AS varchar(4000))

SELECT TOP 1 @ps_assessment_id = assessment_id,
			@ls_old_status = status
FROM c_Assessment_Definition
WHERE assessment_type = @ps_assessment_type
AND description = @ps_description
AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
AND ISNULL(CAST(long_description AS varchar(4000)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
ORDER BY status desc, last_updated desc

SET @ll_rows = @@ROWCOUNT

-- We didn't find an exact match so see if there's a unique match on icd10_code
IF @ll_rows = 0 AND @ps_icd10_code IS NOT NULL AND @ps_allow_dup_icd10_code <> 'Y'
	BEGIN
	SELECT @ll_count = COUNT(*)
	FROM c_Assessment_Definition
	WHERE icd10_code = @ps_icd10_code
	AND status = 'OK'

	IF @ll_count = 1
		BEGIN
		SELECT TOP 1 @ps_assessment_id = assessment_id,
					@ls_old_status = status
		FROM c_Assessment_Definition
		WHERE icd10_code = @ps_icd10_code
		AND status = 'OK'

		SET @ll_rows = @@ROWCOUNT
		END

	END

-- We didn't find a match yet so see if there's match with commas and spaces removed
IF @ll_rows = 0
	BEGIN
	SET @ls_trimmed_description = REPLACE(@ps_description, ',', '')
	SET @ls_trimmed_description = REPLACE(@ls_trimmed_description, ' ', '')

	SELECT TOP 1 @ps_assessment_id = assessment_id,
				@ls_old_status = status
	FROM c_Assessment_Definition
	WHERE REPLACE(REPLACE(description, ',', ''), ' ', '') = @ls_trimmed_description
	AND ISNULL(icd10_code, '<Null>') = ISNULL(@ps_icd10_code, '<Null>')
	AND ISNULL(CAST(long_description AS varchar(4000)), '<Null>') = ISNULL(@ls_long_description_varchar, '<Null>')
	ORDER BY status desc, last_updated desc

	SET @ll_rows = @@ROWCOUNT

	END

IF @ll_rows = 1
	BEGIN
	IF @ls_old_status <> 'OK' AND @ps_status = 'OK'
		UPDATE c_Assessment_Definition
		SET status = @ps_status
		WHERE assessment_id = @ps_assessment_id
	END
ELSE
	BEGIN
	SET @ls_key = CAST(@pl_owner_id AS varchar(12)) + '^'
	
	IF LEN(@ps_icd10_code) >= 3
		SET @ls_key = @ls_key + @ps_icd10_code
	ELSE
		SET @ls_key = @ls_key + CAST(@ps_description AS varchar(12))
	
	SET @ls_key = @ls_key + '^'
	
	EXECUTE sp_get_char_key 'c_Assessment', 'assessment_id', @ls_key, @ls_assessment_id OUTPUT

	INSERT INTO c_Assessment_Definition (
		assessment_id,
		assessment_type,
		icd10_code,
		assessment_category_id,
		description,
		location_domain,
		auto_close,
		auto_close_interval_amount,
		auto_close_interval_unit,
		risk_level,
		complexity,
		owner_id,
		status,
		definition )
	VALUES (
		@ls_assessment_id,
		@ps_assessment_type,
		@ps_icd10_code,
		@ps_assessment_category_id,
		@ps_description,
		@ps_location_domain,
		@ps_auto_close,
		@pi_auto_close_interval_amount,
		@ps_auto_close_interval_unit,
		@pl_risk_level,
		@pl_complexity,
		@pl_owner_id,
		@ps_status,
		@ps_description)

	IF @ps_long_description IS NOT NULL
		UPDATE c_Assessment_Definition
		SET long_description = @ps_long_description
		WHERE assessment_id = @ls_assessment_id

	SET @ps_assessment_id = @ls_assessment_id
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_new_assessment]
	TO [cprsystem]
GO

