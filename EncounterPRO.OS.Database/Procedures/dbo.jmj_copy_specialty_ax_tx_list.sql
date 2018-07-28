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

-- Drop Procedure [dbo].[jmj_copy_specialty_ax_tx_list]
Print 'Drop Procedure [dbo].[jmj_copy_specialty_ax_tx_list]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_copy_specialty_ax_tx_list]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_copy_specialty_ax_tx_list]
GO

-- Create Procedure [dbo].[jmj_copy_specialty_ax_tx_list]
Print 'Create Procedure [dbo].[jmj_copy_specialty_ax_tx_list]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_copy_specialty_ax_tx_list 
	(
	@ps_from_user_id varchar(24) ,
	@ps_to_user_id varchar(24)
	)

WITH RECOMPILE
AS

BEGIN TRANSACTION

DECLARE @ll_from_definition_id int ,
		@ll_to_definition_id int ,		
		@ls_assessment_id varchar(24) ,
		@ls_treatment_type varchar(24) ,
		@ls_treatment_description varchar(255) ,
		@ll_workplan_id int ,
		@ll_followup_workplan_id int ,
		@ls_user_id varchar(24) ,
		@ll_sort_sequence smallint ,
		@ls_instructions varchar(50) ,
		@ll_parent_definition_id int ,
		@ls_child_flag char(1) ,
		@ld_created datetime ,
		@ll_error int



IF @ps_from_user_id = @ps_to_user_id
OR
@ps_from_user_id IS NULL
OR
@ps_to_user_id IS NULL
OR 
@ps_from_user_id NOT in 
	(SELECT user_id from u_assessment_treat_definition)
OR
@ps_to_user_id NOT in 
	(SELECT user_id from u_assessment_treat_definition)
	
	BEGIN
		PRINT 'There was an error with either the FROM or TO user_id in your command line.  Rolling Back Transaction'
			ROLLBACK TRANSACTION
			RETURN
	END

DECLARE @lt_temp_assessment_treat_definition TABLE (
	definition_id int ,
	assessment_id varchar(24) ,
	treatment_type varchar(24) ,
	treatment_description varchar(255) ,
	workplan_id int ,
	followup_workplan_id int ,
	user_id varchar(24) ,
	sort_sequence smallint ,
	instructions varchar(50) ,
	parent_definition_id int ,
	child_flag char(1) ,
	created datetime
	)
	
DECLARE @lt_temp_assessment_treat_def_attrib TABLE (
	definition_id int ,
	attribute_sequence int ,
	attribute varchar(80) ,
	value varchar(255),
	long_value text
	)

UPDATE u_assessment_treat_definition 
SET user_id ='zzz' + @ps_to_user_id
WHERE user_id = @ps_to_user_id

INSERT INTO @lt_temp_assessment_treat_def_attrib (
	definition_id ,
	attribute_sequence ,
	attribute ,
	value,
	long_value
	)
	SELECT a.definition_id ,
		attribute_sequence ,
		attribute ,
		value,
		long_value
	FROM u_assessment_treat_def_attrib a
	INNER JOIN u_assessment_treat_definition u
		ON a.definition_id = u.definition_id
	WHERE u.user_id = @ps_from_user_id


DECLARE lc_copy CURSOR LOCAL FAST_FORWARD FOR
	SELECT definition_id ,
			assessment_id ,
			treatment_type ,
			treatment_description ,
			workplan_id ,
			followup_workplan_id ,
			user_id ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag ,
			created 

	FROM u_assessment_treat_definition
	WHERE user_id = @ps_from_user_id

OPEN lc_copy
FETCH NEXT FROM lc_copy INTO 
	@ll_from_definition_id , 
	@ls_assessment_id ,
	@ls_treatment_type ,
	@ls_treatment_description ,
	@ll_workplan_id ,
	@ll_followup_workplan_id ,
	@ls_user_id ,
	@ll_sort_sequence ,
	@ls_instructions ,
	@ll_parent_definition_id ,
	@ls_child_flag ,
	@ld_created 

WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO u_assessment_treat_definition (
			assessment_id ,
			treatment_type ,
			treatment_description ,
			workplan_id ,
			followup_workplan_id ,
			user_id ,
			sort_sequence ,
			instructions ,
			parent_definition_id ,
			child_flag ,
			created
			)
			VALUES (
				@ls_assessment_id ,
				@ls_treatment_type ,
				@ls_treatment_description ,
				@ll_workplan_id ,
				@ll_followup_workplan_id ,
				@ps_to_user_id ,
				@ll_sort_sequence ,
				@ls_instructions ,
				@ll_parent_definition_id ,
				@ls_child_flag ,
				@ld_created
				)

		SELECT @ll_to_definition_id = SCOPE_IDENTITY()

		UPDATE @lt_temp_assessment_treat_def_attrib
		SET definition_id = @ll_to_definition_id
		WHERE definition_id = @ll_from_definition_id

		SELECT @ll_error = @@ERROR
		IF @ll_error <> 0
			BEGIN
				PRINT 'There was an error with the transaction.  Rolling Back'
				ROLLBACK TRANSACTION
				RETURN
			END

		
		FETCH NEXT FROM lc_copy INTO 
		@ll_from_definition_id , 
		@ls_assessment_id ,
		@ls_treatment_type ,
		@ls_treatment_description ,
		@ll_workplan_id ,
		@ll_followup_workplan_id ,
		@ls_user_id ,
		@ll_sort_sequence ,
		@ls_instructions ,
		@ll_parent_definition_id ,
		@ls_child_flag ,
		@ld_created 

	END

CLOSE lc_copy
DEALLOCATE lc_copy

INSERT INTO u_assessment_treat_def_attrib (definition_id, attribute, value, long_value)
	SELECT definition_id, attribute, value, long_value
	FROM @lt_temp_assessment_treat_def_attrib				

SELECT @ll_error = @@ERROR
IF @ll_error <> 0
	BEGIN
		PRINT 'There was an error with the transaction.  Rolling Back'
		ROLLBACK TRANSACTION
		RETURN
	END

COMMIT TRANSACTION
GO
GRANT EXECUTE
	ON [dbo].[jmj_copy_specialty_ax_tx_list]
	TO [cprsystem]
GO

