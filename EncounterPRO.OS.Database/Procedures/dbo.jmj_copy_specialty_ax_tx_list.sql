
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
	(SELECT [user_id] from u_assessment_treat_definition)
OR
@ps_to_user_id NOT in 
	(SELECT [user_id] from u_assessment_treat_definition)
	
	BEGIN
		PRINT 'There was an error with either the FROM or TO [user_id] in your command line.  Rolling Back Transaction'
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
	long_value varchar(max)
	)

UPDATE u_assessment_treat_definition 
SET [user_id] ='zzz' + @ps_to_user_id
WHERE [user_id] = @ps_to_user_id

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
	WHERE [user_id] = @ps_from_user_id

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

