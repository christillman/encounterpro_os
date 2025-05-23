﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[xml_new_code]
Print 'Drop Procedure [dbo].[xml_new_code]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[xml_new_code]') AND [type]='P'))
DROP PROCEDURE [dbo].[xml_new_code]
GO

-- Create Procedure [dbo].[xml_new_code]
Print 'Create Procedure [dbo].[xml_new_code]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE xml_new_code (
	@pl_owner_id int ,
	@ps_code_domain varchar(40) ,
	@ps_code_version varchar(40) ,
	@ps_code varchar(80) ,
	@ps_description varchar(80) ,
	@ps_epro_domain varchar(64)  ,
	@ps_epro_id varchar(80) OUTPUT ,
	@ps_created_by varchar(24) )
AS
-- This procedure creates a new item or programatically determines a default epro_id
-- for a given owner_id, code_domain, and code.  It is assumed that the lookup in
-- c_XML_Code failed prior to calling this stored procedure.

DECLARE @ls_assessment_type varchar(24)

SET @ps_description = CAST(COALESCE(@ps_description, @ps_code) AS varchar(80))
SET @ps_code = CAST(@ps_code AS varchar(24))

SET @ps_epro_id = NULL

IF @ps_epro_domain = 'sex'
	BEGIN
	IF @ps_description LIKE 'M%'
		SET @ps_epro_id = 'M'
	ELSE
		SET @ps_epro_id = 'F'
	END

IF @ps_epro_domain LIKE '%assessment_id'
	BEGIN
	-- Interpret the characters before "assessment_id" as the assessment_type
	SET @ls_assessment_type = LEFT ( @ps_epro_domain , LEN(@ps_epro_domain) - 14 ) 
	IF @ls_assessment_type IS NULL OR LEN(@ls_assessment_type) = 0
		SET @ls_assessment_type = 'SICK'
	
	-- First see if there's an assessment record already
	SELECT @ps_epro_id = max(assessment_id)
	FROM c_Assessment_Definition
	WHERE assessment_type = @ls_assessment_type
	AND description = @ps_description
	
	IF @ps_epro_id IS NULL
		EXECUTE sp_new_assessment
			@ps_assessment_type = @ls_assessment_type,
			@ps_description = @ps_description,
			@pl_owner_id = @pl_owner_id,
			@ps_status = 'NA',
			@ps_assessment_id = @ps_epro_id OUTPUT
	
	RETURN
	END

IF @ps_epro_domain = 'drug_id'
	BEGIN
	-- First see if there's an assessment record already
	SELECT @ps_epro_id = max(drug_id)
	FROM c_Drug_Definition
	WHERE common_name = @ps_description
	AND generic_name = @ps_code
	
	IF @ps_epro_id IS NULL
		EXECUTE sp_new_drug_definition
			@ps_drug_type = 'Single Drug',
			@ps_common_name = @ps_description,
			@ps_generic_name = @ps_code,
			@pl_owner_id = @pl_owner_id,
			@ps_drug_id = @ps_epro_id OUTPUT
	
	RETURN
	END

IF @ps_epro_domain = 'unit_id'
	BEGIN
	-- First see if there's an assessment record already
	SELECT @ps_epro_id = max(unit_id)
	FROM c_Unit
	WHERE description = @ps_description
	OR description = @ps_code
	
	IF @ps_epro_id IS NULL
		EXECUTE sp_new_unit_id
			@ps_description = @ps_description,
			@pl_owner_id = @pl_owner_id,
			@ps_unit_id = @ps_epro_id OUTPUT
	RETURN
	END


IF @ps_epro_domain = 'administer_method'
	BEGIN
	SET @ps_epro_id = NULL
	
	-- First see if there's an admin_method record already
	SELECT @ps_epro_id = administer_method
	FROM c_Administration_Method
	WHERE administer_method = @ps_code
	
	IF @ps_epro_id IS NULL
		SELECT @ps_epro_id = max(administer_method)
		FROM c_Administration_Method
		WHERE description = @ps_description
	
	IF @ps_epro_id IS NULL
		BEGIN
		INSERT INTO c_Administration_Method (
			administer_method,
			description)
		VALUES (
			@ps_code,
			@ps_description)
		
		SET @ps_epro_id = @ps_code
		END
		
	RETURN
	END

IF @ps_epro_domain = 'administer_frequency'
	BEGIN
	SET @ps_epro_id = NULL
	
	-- First see if there's an admin_method record already
	SELECT @ps_epro_id = administer_frequency
	FROM c_Administration_Frequency
	WHERE administer_frequency = @ps_code
	
	IF @ps_epro_id IS NULL
		SELECT @ps_epro_id = max(administer_frequency)
		FROM c_Administration_Frequency
		WHERE description = @ps_description
	
	IF @ps_epro_id IS NULL
		BEGIN
		INSERT INTO c_Administration_Frequency (
			administer_frequency,
			description,
			status,
			id)
		VALUES (
			@ps_code,
			@ps_description,
			'NA',
			newid())
					
		SET @ps_epro_id = @ps_code
		END
		
	RETURN
	END

IF @ps_epro_domain = 'dosage_form'
	BEGIN
	SET @ps_epro_id = NULL
	
	SELECT @ps_epro_id = max(dosage_form)
	FROM c_Dosage_Form
	WHERE dosage_form = @ps_code
	
	IF @ps_epro_id IS NULL
		SELECT @ps_epro_id = max(dosage_form)
		FROM c_Dosage_Form
		WHERE description = @ps_description
		
	IF @ps_epro_id IS NULL
		BEGIN
		INSERT INTO c_Dosage_Form (
			dosage_form,
			description,
			abbreviation)
		VALUES (
			@ps_code,
			CAST(@ps_description AS varchar(40)),
			@ps_code )

		SET @ps_epro_id = @ps_code
		END
	
	RETURN
	END

IF @ps_epro_domain = 'vaccine_id'
	BEGIN
	SET @ps_epro_id = NULL
	
	SELECT @ps_epro_id = max(vaccine_id)
	FROM c_Vaccine
	WHERE description = @ps_description
	
	IF @ps_epro_id IS NULL
		SELECT @ps_epro_id = max(vaccine_id)
		FROM c_Vaccine
		WHERE vaccine_id = @ps_code
		
	IF @ps_epro_id IS NULL
		BEGIN
		INSERT INTO c_Vaccine (
			vaccine_id,
			description,
			status)
		VALUES (
			@ps_code,
			@ps_description,
			'NA' )

		SET @ps_epro_id = @ps_code
		END
	
	RETURN
	END

IF @ps_epro_domain = 'location'
	BEGIN
	SET @ps_epro_id = NULL
	SET @ps_description = CAST(@ps_description AS varchar(40))
	
	SELECT @ps_epro_id = max(location)
	FROM c_Location
	WHERE description = @ps_description
	AND location_domain = 'NA'
	AND owner_id = @pl_owner_id
	
	IF @ps_epro_id IS NULL
		EXECUTE sp_new_location
			@ps_location = @ps_epro_id OUTPUT,
			@ps_location_domain = 'NA',
			@ps_description = @ps_description,
			@pi_sort_sequence = 999,
			@ps_diffuse_flag = 'N',
			@pl_owner_id = @pl_owner_id
	
	RETURN
	END

IF @ps_epro_domain = 'maker_id'
	BEGIN
	SET @ps_epro_id = NULL
	
	SELECT @ps_epro_id = max(maker_id)
	FROM c_Drug_Maker
	WHERE maker_id = @ps_code

	IF @ps_epro_id IS NULL
		SELECT @ps_epro_id = max(maker_id)
		FROM c_Drug_Maker
		WHERE maker_name = @ps_description
	
	IF @ps_epro_id IS NULL
		BEGIN
		INSERT INTO c_Drug_Maker(
			maker_id,
			maker_name)
		VALUES (
			@ps_code,
			@ps_description)
			
		SET @ps_epro_id = @ps_code
		END
	
	RETURN
	END

IF @ps_epro_domain LIKE '%observation_id'
	BEGIN
	SET @ps_epro_id = NULL
	
	EXECUTE sp_new_observation_record
		@ps_observation_id = @ps_epro_id OUTPUT,
		@ps_description = @ps_description,
		@pl_owner_id = @pl_owner_id,
		@ps_status = 'NA',
		@ps_owner_code_domain = @ps_code_domain ,
		@ps_owner_code = @ps_code ,
		@ps_epro_domain = @ps_epro_domain
		
	RETURN
	END

IF @ps_epro_domain = 'result_sequence'
	BEGIN
	SET @ps_epro_id = NULL
	
	DECLARE @li_result_sequence smallint
	
	EXECUTE sp_new_observation_result
		@ps_observation_id = @ps_code_version,
		@ps_result = @ps_description,
		@ps_status = 'NA',
		@pi_result_sequence = @li_result_sequence OUTPUT

	SET @ps_epro_id = CAST(@li_result_sequence AS varchar(80))

	RETURN
	END

IF @ps_epro_domain = 'abnormal_flag'
	BEGIN
	SET @ps_epro_id = NULL
	
	IF @ps_description IN ('N', 'NA', 'No', 'None', 'Normal')
		SET @ps_epro_id = 'N'
	ELSE
		SET @ps_epro_id = 'Y'
	
	RETURN
	END

IF @ps_epro_domain = 'abnormal_nature'
	BEGIN
	SET @ps_epro_id = CAST(@ps_description AS varchar(8))
	
	RETURN
	END

IF @ps_epro_domain = 'specialty_id'
	BEGIN
	SET @ps_epro_id = NULL
	
	EXECUTE sp_new_specialty
		@ps_specialty_id = @ps_epro_id OUTPUT,
		@ps_description = @ps_description,
		@pl_owner_id = @pl_owner_id,
		@ps_status = 'NA'
		
	RETURN
	END

IF @ps_epro_domain = 'encounter_type'
	BEGIN
	SET @ps_epro_id = @ps_code

	IF NOT EXISTS(SELECT 1 FROM c_Encounter_Type WHERE encounter_type = @ps_code)
		BEGIN
		INSERT INTO c_Encounter_Type (
			encounter_type,
			description,
			status)
		VALUES (
			@ps_code,
			@ps_description,
			'NA')
		END
		
	RETURN
	END

IF @ps_epro_domain = 'treatment_type'
	BEGIN
	SET @ps_epro_id = @ps_code
	
	IF NOT EXISTS(SELECT 1 FROM c_Treatment_Type WHERE treatment_type = @ps_code)
		BEGIN
		INSERT INTO c_Treatment_Type (
			treatment_type,
			component_id,
			description,
			status)
		VALUES (
			@ps_code,
			'TREAT_TEST',
			@ps_description,
			'NA')
		END
		
	RETURN
	END

IF @ps_epro_id IS NULL
	SET @ps_epro_id = @ps_description

GO
GRANT EXECUTE
	ON [dbo].[xml_new_code]
	TO [cprsystem]
GO

