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

-- Drop Procedure [dbo].[sp_create_vial_instance]
Print 'Drop Procedure [dbo].[sp_create_vial_instance]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_create_vial_instance]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_create_vial_instance]
GO

-- Create Procedure [dbo].[sp_create_vial_instance]
Print 'Create Procedure [dbo].[sp_create_vial_instance]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_create_vial_instance (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pl_parent_treatment_id integer,
	@ps_vial_type varchar(24),
	@ps_ordered_by varchar(24) = NULL,
	@ps_created_by varchar(24) = NULL,
	@ps_dilute_from_vial_type varchar(24) = NULL,
	@pr_vial_amount real = NULL,
	@ps_vial_unit varchar(24) = NULL
)

AS

DECLARE @ll_count int,
	@ls_description varchar(80),
	@ls_definition_status varchar(40),
	@ll_treatment_id int,
	@ll_full_strength_ratio int,
	@ls_next_dilute_from_vial_type varchar(24),
	@ls_dilute_from_vial_type varchar(24),
	@ll_dilute_ratio int,
	@ll_next_dilute_ratio int,
	@ll_total_dilute_ratio int,
	@lr_default_amount real,
	@ls_default_unit varchar(24),
	@ldt_expiration_date datetime,
	@ll_from_treatment_id int,
	@ls_expiration_date varchar(24)

SET @ls_definition_status = dbo.fn_patient_object_property (@ps_cpr_id ,
															'Treatment' ,
															@pl_parent_treatment_id ,
															'Vial Definition' )

IF @ls_definition_status IS NULL OR @ls_definition_status <> 'Ready'
	RETURN 0

-- Get info about the vial type, using the passed in dilute_from value if it exists
SELECT @ll_full_strength_ratio = full_strength_ratio,
	@ls_next_dilute_from_vial_type = dilute_from_vial_type,
	@ll_next_dilute_ratio = dilute_ratio,
	@lr_default_amount = default_amount,
	@ls_default_unit = default_unit
FROM c_Vial_Type
WHERE vial_type = @ps_vial_type

IF @@ROWCOUNT <> 1
	BEGIN
	RAISERROR ('Cannot find vial_type (%s)',16, -1, @ps_vial_type)
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ps_dilute_from_vial_type IS NULL OR @ls_next_dilute_from_vial_type = @ps_dilute_from_vial_type
	BEGIN
	-- The caller did not specify a dilute-from vial type, or the one specified is
	-- the next one anyways, so just dilute from the next most concentrated vial type
	SET @ll_dilute_ratio = @ll_next_dilute_ratio
	SET @ls_dilute_from_vial_type = @ls_next_dilute_from_vial_type
	END
ELSE
	BEGIN
	-- The caller specified a dilute-from vial type that's not the direct dilution
	-- from the new vial type.  Loop up through the vial types to find the specified
	-- dilute-from vial type.  Keep track of the dilution ratio along the way.
	SET @ll_total_dilute_ratio = @ll_next_dilute_ratio
	SET @ls_dilute_from_vial_type = @ls_next_dilute_from_vial_type
	WHILE 1 = 1
		BEGIN
		SELECT @ls_dilute_from_vial_type = dilute_from_vial_type,
			@ll_dilute_ratio = dilute_ratio
		FROM c_Vial_Type
		WHERE vial_type = @ls_dilute_from_vial_type
		IF @@ROWCOUNT <> 1 OR @ls_dilute_from_vial_type IS NULL OR @ll_dilute_ratio IS NULL
			BEGIN
			-- We never found the specified vial type so throw an error
			RAISERROR ('Could not determine ratio for specified dilute-from vial type (%s)',16,-1, @ps_dilute_from_vial_type)
			ROLLBACK TRANSACTION
			RETURN -1
			END

		SET @ll_total_dilute_ratio = @ll_total_dilute_ratio * @ll_dilute_ratio
		
		IF @ll_total_dilute_ratio > @ll_full_strength_ratio		
			BEGIN
			-- We've calculated a total dilution ratio that exceeds the ratio for the disired vial
			-- This indicates an improperly configured set of vials so throw an error
			RAISERROR ('The calculated dilution ratio is invalid for the specified dilute-from vial type (%s)',16,-1, @ps_dilute_from_vial_type)
			ROLLBACK TRANSACTION
			RETURN -1
			END
		
		IF @ls_dilute_from_vial_type = @ps_dilute_from_vial_type
			BEGIN
			-- We found the specified dilute-from vial type!
			SET @ll_dilute_ratio = @ll_total_dilute_ratio
			SET @ls_dilute_from_vial_type = @ps_dilute_from_vial_type
			BREAK
			END
		END
	END


IF @ll_full_strength_ratio = 1
	BEGIN
	-- If this is a full strength vial, then we must use the definition vial size
	SELECT @pr_vial_amount = dose_amount,
		@ps_vial_unit = dose_unit
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_parent_treatment_id

	IF @@ROWCOUNT <> 1
		BEGIN
		RAISERROR ('Error getting parent dose info',16,-1)
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END
ELSE
	BEGIN
	-- If the caller didn't specify a dose, then use the default from the vial type
	IF @pr_vial_amount IS NULL OR @ps_vial_unit IS NULL 
		BEGIN
		SET @pr_vial_amount = @lr_default_amount
		SET @ps_vial_unit = @ls_default_unit
		END

	-- If the vial type doesn't specify a dose amount, then get the dose info from the parent
	IF @pr_vial_amount IS NULL OR @ps_vial_unit IS NULL
		BEGIN
		SELECT @pr_vial_amount = dose_amount,
			@ps_vial_unit = dose_unit
		FROM p_Treatment_Item
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_parent_treatment_id

		IF @@ROWCOUNT <> 1
			BEGIN
			RAISERROR ('Error getting parent dose info',16,-1)
			ROLLBACK TRANSACTION
			RETURN -1
			END
		END
	END

-- if there is already an vial with incomplete status ('NEW')
-- then do not create any new vials
SELECT @ll_treatment_id = max(treatment_id)
FROM p_Treatment_Item WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id
AND parent_treatment_id = @pl_parent_treatment_id
AND treatment_type = 'AllergyVialInstance'
AND treatment_description LIKE @ps_vial_type + '%'
AND treatment_status = 'NEW'

IF @ll_treatment_id > 0
	RETURN @ll_treatment_id



SELECT @ll_count = count(*)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND parent_treatment_id = @pl_parent_treatment_id
AND treatment_type = 'AllergyVialInstance'
AND vial_type = @ps_vial_type

IF @ll_count is NULL
	SELECT @ll_count = 0

SET @ll_count = @ll_count + 1
SET @ls_description = dbo.fn_vial_type_description(@ps_vial_type) + ' # ' + CAST(@ll_count AS varchar(3))

-- Pick up the default dose amount and unit from the parent treatment
INSERT INTO p_treatment_item (
		cpr_id,
		open_encounter_id,
		treatment_type,
		treatment_description,
		vial_type,
		begin_date,
		dose_amount,
		dose_unit,
		treatment_status,
		parent_treatment_id,
		ordered_by,
		created_by )
VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		'AllergyVialInstance',
		@ls_description,
		@ps_vial_type,
		dbo.get_client_datetime(),
		@pr_vial_amount,
		@ps_vial_unit,
		'NEW',
		@pl_parent_treatment_id,
		@ps_ordered_by,
		@ps_created_by )

SELECT @ll_treatment_id = scope_identity()


IF @ll_full_strength_ratio = 1
	BEGIN
	INSERT INTO p_Treatment_Item ( 
		cpr_id,
		open_encounter_id,
		treatment_type,
		treatment_description,
		package_id,
		drug_id,
		dose_amount,
		dose_unit,
		begin_date,
		treatment_status,
		parent_treatment_id,
		ordered_by,
		created_by )
	SELECT @ps_cpr_id,
		@pl_encounter_id,
		'AllergyVialAllergen',
		treatment_description,
		package_id,
		drug_id,
		dose_amount,
		dose_unit,
		dbo.get_client_datetime(),
		'OPEN',
		@ll_treatment_id,
		@ps_ordered_by,
		@ps_created_by
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND parent_treatment_id = @pl_parent_treatment_id
	AND treatment_type = 'AllergyVialDefinition'
	AND ISNULL(treatment_status, 'OPEN') = 'OPEN'
	END
ELSE
	BEGIN
	SET @ls_description = @ls_dilute_from_vial_type + ' Vial'
	
	INSERT INTO p_Treatment_Item ( 
		cpr_id,
		open_encounter_id,
		treatment_type,
		treatment_description,
		vial_type,
		dose_amount,
		dose_unit,
		begin_date,
		treatment_status,
		parent_treatment_id,
		ordered_by,
		created_by )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		'AllergyVialAllergen',
		@ls_description,
		@ls_dilute_from_vial_type,
		@pr_vial_amount / @ll_dilute_ratio,
		@ps_vial_unit,
		dbo.get_client_datetime(),
		'OPEN',
		@ll_treatment_id,
		@ps_ordered_by,
		@ps_created_by )
	
	INSERT INTO p_Treatment_Item ( 
		cpr_id,
		open_encounter_id,
		treatment_type,
		treatment_description,
		dose_amount,
		dose_unit,
		begin_date,
		treatment_status,
		parent_treatment_id,
		ordered_by,
		created_by )
	VALUES (
		@ps_cpr_id,
		@pl_encounter_id,
		'AllergyVialAllergen',
		'Diluent',
		@pr_vial_amount - (@pr_vial_amount / @ll_dilute_ratio) ,
		@ps_vial_unit,
		dbo.get_client_datetime(),
		'OPEN',
		@ll_treatment_id,
		@ps_ordered_by,
		@ps_created_by )
	
	-- See if we can get the expiration date from the parent vial
	SELECT @ll_from_treatment_id = min(treatment_id)
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND parent_treatment_id = @pl_parent_treatment_id
	AND vial_type = @ls_dilute_from_vial_type
	AND treatment_type = 'AllergyVialInstance'
	AND ISNULL(treatment_status, 'OPEN') = 'OPEN'
	
	IF @ll_from_treatment_id > 0
		BEGIN
		SELECT @ls_expiration_date = CAST(expiration_date AS varchar(24))
		FROM p_Treatment_Item
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @ll_from_treatment_id
		
		IF LEN(@ls_expiration_date) > 0
			EXECUTE sp_set_treatment_progress	@ps_cpr_id = @ps_cpr_id,
												@pl_treatment_id = @ll_treatment_id,
												@pl_encounter_id = @pl_encounter_id,
												@ps_progress_type = 'Modify',
												@ps_progress_key = 'expiration_date',
												@ps_progress = @ls_expiration_date,
												@ps_user_id = @ps_ordered_by,
												@ps_created_by = @ps_created_by
		END
	END

RETURN @ll_treatment_id

GO
GRANT EXECUTE
	ON [dbo].[sp_create_vial_instance]
	TO [cprsystem]
GO

