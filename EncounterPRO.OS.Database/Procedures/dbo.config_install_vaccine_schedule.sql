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

-- Drop Procedure [dbo].[config_install_vaccine_schedule]
Print 'Drop Procedure [dbo].[config_install_vaccine_schedule]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[config_install_vaccine_schedule]') AND [type]='P'))
DROP PROCEDURE [dbo].[config_install_vaccine_schedule]
GO

-- Create Procedure [dbo].[config_install_vaccine_schedule]
Print 'Create Procedure [dbo].[config_install_vaccine_schedule]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE config_install_vaccine_schedule (
	@pui_config_object_id uniqueidentifier ,
	@pl_version int )
AS
--
-- Returns:
-- -1 An error occured
--

DECLARE @ll_error int,
		@ll_rowcount int,
		@lx_xml xml,
		@ll_doc int,
		@ls_age_range_category varchar(24),
		@ls_description varchar(40),
		@ll_age_from int,
		@ls_age_from_unit varchar(24),
		@ll_age_to int,
		@ls_age_to_unit varchar(24),
		@ll_age_range_id int,
		@ll_new_age_range_id int,
		@ls_config_object_id varchar(40),
		@ll_domain_sequence int

DECLARE @Age_Ranges TABLE (
	age_range_id int NOT NULL,
	age_range_category varchar(24) NOT NULL,
	description varchar(40) NULL,
	age_from int NULL,
	age_from_unit varchar(24) NULL,
	age_to int NULL,
	age_to_unit varchar(24) NULL,
	new_age_range_id int NULL
	)

IF @pui_config_object_id IS NULL
	BEGIN
	RAISERROR ('NULL config_object_id',16,-1)
	RETURN -1
	END

IF @pl_version IS NULL
	BEGIN
	RAISERROR ('NULL version',16,-1)
	RETURN -1
	END

SET @ls_config_object_id = CAST(@pui_config_object_id AS varchar(40))

SELECT @lx_xml = CAST(CAST(objectdata AS varbinary(max)) AS xml)
FROM dbo.c_Config_Object_Version
WHERE config_object_id = @pui_config_object_id
AND version = @pl_version

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_rowcount <> 1
	BEGIN
	RAISERROR ('The specified config object was not found (%s, %d)',16,-1, @ls_config_object_id, @pl_version)
	RETURN -1
	END

SELECT @ll_domain_sequence = max(domain_sequence)
FROM c_Domain
WHERE domain_id = 'Config Vaccine Schedule'

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

EXEC sp_xml_preparedocument @ll_doc OUTPUT, @lx_xml

INSERT INTO @Age_Ranges (
	age_range_id,
	age_range_category,
	description,
	age_from,
	age_from_unit,
	age_to,
	age_to_unit)
SELECT age_range_id,
	age_range_category,
	description,
	age_from,
	age_from_unit,
	age_to,
	age_to_unit
FROM   OPENXML (@ll_doc, '/EPConfigObjects/VaccineSchedule/AgeRange',1)
		WITH (	age_range_id int ,
				age_range_category varchar(24) ,
				description varchar(40) ,
				age_from int ,
				age_from_unit varchar(24) ,
				age_to int ,
				age_to_unit varchar(24)
			)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

DECLARE lc_ar CURSOR LOCAL FAST_FORWARD FOR
	SELECT 	age_range_id,
			age_range_category,
			description,
			age_from,
			age_from_unit,
			age_to,
			age_to_unit
	FROM @Age_Ranges

OPEN lc_ar

FETCH lc_ar INTO @ll_age_range_id,
				@ls_age_range_category,
				@ls_description,
				@ll_age_from,
				@ls_age_from_unit,
				@ll_age_to,
				@ls_age_to_unit

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE jmj_new_age_range
		@ps_age_range_category = @ls_age_range_category,
		@ps_description = @ls_description,
		@pl_age_from = @ll_age_from,
		@ps_age_from_unit = @ls_age_from_unit,
		@pl_age_to = @ll_age_to,
		@ps_age_to_unit = @ls_age_to_unit,
		@pl_age_range_id = @ll_new_age_range_id OUTPUT

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN -1

	UPDATE @Age_Ranges
	SET new_age_range_id = @ll_new_age_range_id
	WHERE age_range_id = @ll_age_range_id

	FETCH lc_ar INTO @ll_age_range_id,
					@ls_age_range_category,
					@ls_description,
					@ll_age_from,
					@ls_age_from_unit,
					@ll_age_to,
					@ls_age_to_unit
	END

CLOSE lc_ar
DEALLOCATE lc_ar


BEGIN TRANSACTION

DELETE FROM c_Immunization_Dose_Schedule

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

DELETE FROM c_Disease_Group_Item

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

DELETE FROM c_Disease_Group

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END


INSERT INTO c_Disease_Group (
	disease_group ,
	description ,
	sort_sequence ,
	status ,
	age_range ,
	sex ,
	id ,
	last_updated ,
	owner_id )
SELECT disease_group ,
	description ,
	sort_sequence ,
	status ,
	age_range ,
	sex ,
	id ,
	last_updated ,
	owner_id
FROM   OPENXML (@ll_doc, '/EPConfigObjects/VaccineSchedule/DiseaseGroup',1)
		WITH (	disease_group varchar(24),
				description varchar(255),
				sort_sequence int,
				status varchar(12),
				age_range int,
				sex char(1),
				id uniqueidentifier,
				last_updated datetime,
				owner_id int
			)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE dg
SET age_range = x.new_age_range_id
FROM c_Disease_Group dg
	INNER JOIN @Age_Ranges x
	ON dg.age_range = x.age_range_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

INSERT INTO c_Disease_Group_Item (
	disease_group ,
	disease_id ,
	sort_sequence ,
	id ,
	last_updated ,
	owner_id )
SELECT disease_group ,
	disease_id ,
	sort_sequence ,
	id ,
	last_updated ,
	owner_id
FROM   OPENXML (@ll_doc, '/EPConfigObjects/VaccineSchedule/DiseaseGroupItem',1)
		WITH (	disease_group varchar(24) ,
				disease_id int ,
				sort_sequence int ,
				id uniqueidentifier ,
				last_updated datetime ,
				owner_id int 
			)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

INSERT INTO c_Immunization_Dose_Schedule (
	disease_id ,
	dose_number ,
	patient_age_range_id ,
	first_dose_age_range_id ,
	last_dose_age_range_id ,
	last_dose_interval_amount ,
	last_dose_interval_unit_id ,
	sort_sequence ,
	dose_text )
SELECT disease_id ,
	dose_number ,
	patient_age_range_id ,
	first_dose_age_range_id ,
	last_dose_age_range_id ,
	last_dose_interval_amount ,
	last_dose_interval_unit_id ,
	sort_sequence ,
	dose_text
FROM   OPENXML (@ll_doc, '/EPConfigObjects/VaccineSchedule/DoseSchedule',1)
		WITH (	disease_id int ,
				dose_schedule_sequence int ,
				dose_number int ,
				patient_age_range_id int ,
				first_dose_age_range_id int ,
				last_dose_age_range_id int ,
				last_dose_interval_amount int ,
				last_dose_interval_unit_id varchar(24) ,
				sort_sequence int ,
				dose_text varchar(255) 
			)

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE ds
SET patient_age_range_id = x.new_age_range_id
FROM c_Immunization_Dose_Schedule ds
	INNER JOIN @Age_Ranges x
	ON ds.patient_age_range_id = x.age_range_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE ds
SET first_dose_age_range_id = x.new_age_range_id
FROM c_Immunization_Dose_Schedule ds
	INNER JOIN @Age_Ranges x
	ON ds.first_dose_age_range_id = x.age_range_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

UPDATE ds
SET last_dose_age_range_id = x.new_age_range_id
FROM c_Immunization_Dose_Schedule ds
	INNER JOIN @Age_Ranges x
	ON ds.last_dose_age_range_id = x.age_range_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	BEGIN
	ROLLBACK TRANSACTION
	RETURN -1
	END

IF @ll_domain_sequence IS NULL
	BEGIN
	SET @ll_domain_sequence = 1

	INSERT INTO c_Domain (
		domain_id,
		domain_sequence,
		domain_item)
	VALUES (
		'Config Vaccine Schedule',
		@ll_domain_sequence,
		@ls_config_object_id)

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END
ELSE
	BEGIN
	UPDATE c_Domain
	SET domain_item = @ls_config_object_id
	WHERE domain_id = 'Config Vaccine Schedule'
	AND domain_sequence = @ll_domain_sequence

	SELECT @ll_error = @@ERROR,
			@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		BEGIN
		ROLLBACK TRANSACTION
		RETURN -1
		END
	END

COMMIT TRANSACTION

EXEC sp_xml_removedocument @ll_doc

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[config_install_vaccine_schedule]
	TO [cprsystem]
GO

