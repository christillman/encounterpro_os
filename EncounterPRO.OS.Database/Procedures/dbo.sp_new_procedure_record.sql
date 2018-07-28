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

-- Drop Procedure [dbo].[sp_new_procedure_record]
Print 'Drop Procedure [dbo].[sp_new_procedure_record]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_new_procedure_record]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_new_procedure_record]
GO

-- Create Procedure [dbo].[sp_new_procedure_record]
Print 'Create Procedure [dbo].[sp_new_procedure_record]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_new_procedure_record (
	@ps_procedure_id varchar(24) OUTPUT,
	@ps_procedure_type varchar(12),
	@ps_cpt_code varchar(24),
	@pdc_charge decimal = NULL,
	@ps_procedure_category_id varchar(24),
	@ps_description varchar(80),
	@ps_service varchar(24) = NULL,
	@ps_vaccine_id varchar(24) = NULL,
	@pr_units float,
	@ps_modifier varchar(2) = NULL,
	@ps_other_modifiers varchar(12) = NULL,
	@ps_billing_id varchar(24) = NULL,
	@ps_location_domain varchar(12) = NULL,
	@pi_risk_level integer = NULL,
	@ps_default_bill_flag char(1) = NULL,
	@pl_owner_id int = NULL,
	@ps_status varchar(12) = NULL,
	@ps_allow_dup_cpt_code char(1) = 'Y',
	@ps_long_description text = NULL,
	@ps_default_location varchar(24)= NULL,
	@ps_bill_assessment_id varchar(24) = NULL,
	@ps_well_encounter_flag char(1) = NULL
	)
AS

DECLARE @ll_key_value integer,
	@ls_old_status varchar(12) ,
	@ll_rows int,
	@ll_count int,
	@ls_trimmed_description varchar(80)

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_allow_dup_cpt_code IS NULL
	SET @ps_allow_dup_cpt_code = 'Y'

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

SELECT TOP 1 @ps_procedure_id = procedure_id,
			@ls_old_status = status
FROM c_Procedure
WHERE procedure_type = @ps_procedure_type
AND description = @ps_description
AND ISNULL(cpt_code, '<Null>') = ISNULL(@ps_cpt_code, '<Null>')
ORDER BY status desc, last_updated desc

SET @ll_rows = @@ROWCOUNT

-- We didn't find an exact match so see if there's a unique match on cpt_code
IF @ll_rows = 0 AND @ps_cpt_code IS NOT NULL AND @ps_allow_dup_cpt_code <> 'Y'
	BEGIN
	SELECT @ll_count = COUNT(*)
	FROM c_Procedure
	WHERE cpt_code = @ps_cpt_code
	AND status = 'OK'

	IF @ll_count = 1
		BEGIN
		SELECT TOP 1 @ps_procedure_id = procedure_id,
					@ls_old_status = status
		FROM c_Procedure
		WHERE cpt_code = @ps_cpt_code
		AND status = 'OK'

		SET @ll_rows = @@ROWCOUNT
		END

	END

-- We didn't find a match yet so see if there's match with commas and spaces removed
IF @ll_rows = 0
	BEGIN
	SET @ls_trimmed_description = REPLACE(@ps_description, ',', '')
	SET @ls_trimmed_description = REPLACE(@ls_trimmed_description, ' ', '')

	SELECT TOP 1 @ps_procedure_id = procedure_id,
				@ls_old_status = status
	FROM c_Procedure
	WHERE REPLACE(REPLACE(description, ',', ''), ' ', '') = @ls_trimmed_description
	AND ISNULL(cpt_code, '<Null>') = ISNULL(@ps_cpt_code, '<Null>')
	ORDER BY status desc, last_updated desc

	SET @ll_rows = @@ROWCOUNT

	END

IF @ll_rows = 1
	BEGIN
	IF @ls_old_status <> 'OK' AND @ps_status = 'OK'
		UPDATE c_Procedure
		SET status = @ps_status
		WHERE procedure_id = @ps_procedure_id
	END
ELSE
	BEGIN

	EXECUTE sp_get_next_key
		@ps_cpr_id = '!CPR',
		@ps_key_id = 'PROCEDURE_ID',
		@pl_key_value = @ll_key_value OUTPUT
	SELECT @ps_procedure_id = office_id + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
	FROM o_Office
	WHILE exists(select * from c_Procedure where procedure_id = @ps_procedure_id)
		BEGIN
		EXECUTE sp_get_next_key
			@ps_cpr_id = '!CPR',
			@ps_key_id = 'PROCEDURE_ID',
			@pl_key_value = @ll_key_value OUTPUT
		SELECT @ps_procedure_id = office_id + ltrim(rtrim(convert(varchar(12),@ll_key_value)))
		FROM o_Office
		END

	IF @ps_default_bill_flag IS NULL
		SET @ps_default_bill_flag = 'Y'

	INSERT INTO c_Procedure (
		procedure_id,
		procedure_type,
		cpt_code,
		charge,
		procedure_category_id,
		description,
		service,
		vaccine_id,
		units,
		modifier,
		other_modifiers,
		billing_id,
		location_domain,
		risk_level,
		status,
		default_bill_flag,
		owner_id,
		definition,
		original_cpt_code,
		long_description,
		default_location,
		bill_assessment_id,
		well_encounter_flag
 )
	VALUES (
		@ps_procedure_id,
		@ps_procedure_type,
		@ps_cpt_code,
		CAST(@pdc_charge AS money),
		@ps_procedure_category_id,
		@ps_description,
		@ps_service,
		@ps_vaccine_id,
		@pr_units,
		@ps_modifier,
		@ps_other_modifiers,
		@ps_billing_id,
		@ps_location_domain,
		@pi_risk_level,
		@ps_status,
		@ps_default_bill_flag,
		@pl_owner_id,
		@ps_description,
		@ps_cpt_code,
		@ps_long_description,
		@ps_default_location,
		@ps_bill_assessment_id,
		@ps_well_encounter_flag
		 )
	END


GO
GRANT EXECUTE
	ON [dbo].[sp_new_procedure_record]
	TO [cprsystem]
GO

