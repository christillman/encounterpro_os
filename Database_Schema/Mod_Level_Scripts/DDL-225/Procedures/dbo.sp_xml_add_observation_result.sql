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

-- Drop Procedure [dbo].[sp_xml_add_observation_result]
Print 'Drop Procedure [dbo].[sp_xml_add_observation_result]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_xml_add_observation_result]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_xml_add_observation_result]
GO

-- Create Procedure [dbo].[sp_xml_add_observation_result]
Print 'Create Procedure [dbo].[sp_xml_add_observation_result]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_xml_add_observation_result (
	@pl_observation_sequence int,
	@ps_location varchar(24),
	@ps_result varchar(80),
	@ps_result_value text = NULL,
	@ps_print_result_flag char(1),
	@ps_result_unit varchar(12),
	@ps_abnormal_flag char(1),
	@ps_abnormal_nature varchar(8),
	@pi_severity smallint,
	@ps_observed_by varchar(24),
	@ps_created_by varchar(24) = NULL,
	@pdt_result_date_time datetime = NULL,
	@pl_encounter_id int = NULL,
	@pl_attachment_id int = NULL,
	@ps_normal_range varchar(40) = NULL)
AS

DECLARE @ls_cpr_id varchar(12),
		@ls_observation_id varchar(24),
		@ls_result_amount_flag char(1),
		@ls_result_value varchar(40),
		@ll_treatment_id int,
		@ls_comment_type varchar(24),
		@ls_comment_title varchar(48),
		@ll_result_value_length int,
		@ls_observation_description varchar(80),
		@ll_tmp_sequence int,
		@ls_display_mask varchar(40),
		@ls_existing_display_mask varchar(40),
		@ll_mask_point int,
		@ll_value_point int,
		@ll_mask_precision int,
		@ll_value_precision int,
		@ls_unit_type varchar(12),
		@ll_count int,
		@ll_error int

DECLARE @ll_location_result_sequence int, @ll_result_sequence int


-- treat empty string as NULL
IF @ps_location = ''
	SET @ps_location = NULL

IF @ps_result_unit = ''
	SET @ps_result_unit = NULL

IF @ps_abnormal_flag = ''
	SET @ps_abnormal_flag = NULL

IF @ps_abnormal_nature = ''
	SET @ps_abnormal_nature = NULL

IF @ps_observed_by = ''
	SET @ps_observed_by = NULL

IF @ps_created_by = ''
	SET @ps_created_by = NULL



-- Get the length of the result_value
SET @ll_result_value_length = LEN(ISNULL(CONVERT(varchar(255), @ps_result_value), ''))

IF @ps_result_unit IS NULL
	BEGIN
	IF @ll_result_value_length = 0
		SET @ls_result_amount_flag = 'N'
	ELSE
		BEGIN
		SET @ls_result_amount_flag = 'Y'
		SET @ps_result_unit = 'TEXT'
		END
	END
ELSE
	BEGIN
	IF @ll_result_value_length = 0 AND @ps_result_unit = 'NA'
		SET @ls_result_amount_flag = 'N'
	ELSE
		BEGIN
		SET @ls_result_amount_flag = 'Y'
		END
	END

-- Get some info from p_Observation
SELECT @ls_cpr_id = cpr_id,
		@ls_observation_id = observation_id,
		@pl_encounter_id = COALESCE(@pl_encounter_id, encounter_id),
		@ll_treatment_id = treatment_id,
		@ls_observation_description = description
FROM p_Observation
WHERE observation_sequence = @pl_observation_sequence

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN -1

IF @ll_count <> 1
	BEGIN
	RAISERROR ('The observation_sequence was not found (%d)',16,-1, @pl_observation_sequence)
	RETURN -1
	END

-- If the observed_by is null then look it up from a previous result
IF @ps_observed_by IS NULL
	BEGIN
	SELECT @ll_tmp_sequence = max(location_result_sequence)
	FROM p_Observation_Result
	WHERE cpr_id = @ls_cpr_id
	AND observation_sequence = @pl_observation_sequence
	
	IF @ll_tmp_sequence IS NULL
		BEGIN
		SELECT @ll_tmp_sequence = max(observation_comment_id)
		FROM p_Observation_Comment
		WHERE cpr_id = @ls_cpr_id
		AND observation_sequence = @pl_observation_sequence
		
		IF @ll_tmp_sequence IS NULL
			BEGIN
			-- if we still don't have one, then check the p_Observation record
			SELECT @ps_observed_by = observed_by
			FROM p_Observation
			WHERE cpr_id = @ls_cpr_id
			AND observation_sequence = @pl_observation_sequence
			
			IF @ps_observed_by IS NULL
				BEGIN
				RAISERROR ('Observed_By Not Provided (%s, %d)',16,-1, @ls_cpr_id, @pl_observation_sequence)
				ROLLBACK TRANSACTION
				RETURN
				END
			END
		
		SELECT @ps_observed_by = user_id
		FROM p_Observation_Comment
		WHERE cpr_id = @ls_cpr_id
		AND observation_sequence = @pl_observation_sequence
		AND observation_comment_id = @ll_tmp_sequence
		END
	ELSE
		SELECT @ps_observed_by = observed_by
		FROM p_Observation_Result
		WHERE cpr_id = @ls_cpr_id
		AND observation_sequence = @pl_observation_sequence
		AND location_result_sequence = @ll_tmp_sequence
		
	END

-- Use Observed_by as created_by if created_by wasn't supplied
SET @ps_created_by = COALESCE(@ps_created_by, @ps_observed_by)


-- Make sure we have either a result or result_value
IF @ps_result IS NULL
	BEGIN
	IF @ll_result_value_length = 0
		RETURN 0
	ELSE
		BEGIN
		SET @ps_result = @ls_observation_description
		SET @ps_print_result_flag = 'N'
		END
	END


IF @ps_abnormal_flag IS NULL
	SET @ps_abnormal_flag = 'N'

IF @ps_print_result_flag IS NULL
	SET @ps_print_result_flag = 'N'

/*
notes from conversation w/mark
have obs id, determine result sequence
match on result text
include additional tags
if can't find, call sp_new_observation_result
*/

-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].

IF @ll_result_value_length <= 40 AND @pl_attachment_id IS NULL
	BEGIN
	-- For results, if no date/time is passed in then use the current date/time
	SET @pdt_result_date_time = COALESCE(@pdt_result_date_time, dbo.get_client_datetime())

	SET @ls_result_value = CONVERT(varchar(40), @ps_result_value)
	IF @ls_result_value = ''
		SET @ls_result_value = NULL

	EXECUTE sp_new_observation_result
		@ps_observation_id = @ls_observation_id,
		@ps_result = @ps_result,
		@ps_result_amount_flag = @ls_result_amount_flag,
		@ps_print_result_flag = @ps_print_result_flag,
		@ps_result_unit = @ps_result_unit,
		@ps_abnormal_flag = @ps_abnormal_flag,
		@pi_severity = @pi_severity,
		@pi_result_sequence = @ll_result_sequence OUTPUT

	-- Update the display mask assuming that the number of digits provided to
	-- the right of the decimal is the desired precision, including trailing zeros
	SET @ls_display_mask = NULL

	SELECT @ls_existing_display_mask = display_mask,
			@ls_unit_type = unit_type
	FROM c_Unit
	WHERE unit_id = @ps_result_unit

	IF @ls_unit_type = 'NUMBER'
		BEGIN
		SET @ll_mask_point = CHARINDEX('.', @ls_existing_display_mask)
		SET @ll_value_point = CHARINDEX('.', @ls_result_value)

		IF @ll_value_point = 0
			BEGIN
			IF @ls_existing_display_mask IS NULL OR @ls_existing_display_mask <> '#'
				SET @ls_display_mask = '#'
			END
		ELSE
			BEGIN
			SET @ll_mask_precision = 0
			WHILE 1 = 1
				BEGIN
				IF SUBSTRING(@ls_existing_display_mask, @ll_mask_point + @ll_mask_precision + 1, 1) = '0'
					SET @ll_mask_precision = @ll_mask_precision + 1
				ELSE
					BREAK
				END

			SET @ll_value_precision = LEN(@ls_result_value) - @ll_value_point

			IF @ll_mask_precision <> @ll_value_precision OR @ll_mask_precision IS NULL
				SET @ls_display_mask = '0.' + REPLICATE('0', @ll_value_precision)
			END

		IF @ls_display_mask IS NOT NULL
			UPDATE c_Observation_Result
			SET display_mask = @ls_display_mask
			WHERE observation_id = @ls_observation_id
			AND result_sequence = @ll_result_sequence
		END

	-- Create P record
	INSERT INTO p_Observation_Result
		(
		cpr_id,
		observation_sequence,
		location,
		encounter_id,
		treatment_id,
		observation_id,
		result_sequence,
		result_type,
		result,
		result_date_time,
		result_value,
		result_unit,
		abnormal_flag,
		abnormal_nature,
		severity,
		observed_by,
		current_flag,
		normal_range,
		created_by
		)
	VALUES (
		@ls_cpr_id,
		@pl_observation_sequence,
		@ps_location,
		@pl_encounter_id,
		@ll_treatment_id,
		@ls_observation_id,
		@ll_result_sequence, 
		'PERFORM',
		@ps_result,
		@pdt_result_date_time,
		@ps_result_value,
		@ps_result_unit,
		@ps_abnormal_flag,
		@ps_abnormal_nature,
		@pi_severity,
		@ps_observed_by,
		'Y',
		@ps_normal_range,
		@ps_created_by
		)
	SET @ll_location_result_sequence = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
	
	IF @ps_result IS NULL
		BEGIN
		IF @pl_attachment_id IS NULL
			SET @ls_comment_title = 'Comment'
		ELSE
			SET @ls_comment_title = 'Attachment'
		END
	ELSE
		SET @ls_comment_title = CAST(@ps_result AS varchar(48))

	IF @pl_attachment_id IS NULL
		SET @ls_comment_type = 'Comment'
	ELSE
		SET @ls_comment_type = 'Attachment'

	-- For comments, if no date/time is passed in then use the date/time of the most recent
	-- comment with the same comment_title
	IF @pdt_result_date_time IS NULL
		BEGIN
		SELECT @pdt_result_date_time = max(comment_date_time)
		FROM p_Observation_Comment
		WHERE cpr_id = @ls_cpr_id
		AND observation_sequence = @pl_observation_sequence
		AND comment_type = @ls_comment_type
		AND comment_title = @ls_comment_title
		END
		
	-- If we still don't have a date/time, use the current date/time
	SET @pdt_result_date_time = COALESCE(@pdt_result_date_time, dbo.get_client_datetime())
	
	EXECUTE sp_set_observation_comment
				@ps_cpr_id = @ls_cpr_id,
				@pl_observation_sequence = @pl_observation_sequence,
				@ps_observation_id = @ls_observation_id,
				@ps_comment_type = @ls_comment_type,
				@ps_comment_title = @ls_comment_title,
				@pdt_comment_date_time = @pdt_result_date_time,
				@ps_comment = @ps_result_value,
				@ps_abnormal_flag = @ps_abnormal_flag,
				@pi_severity = @pi_severity,
				@pl_treatment_id = @ll_treatment_id,
				@pl_encounter_id = @pl_encounter_id,
				@pl_attachment_id = @pl_attachment_id,
				@ps_user_id = @ps_observed_by,
				@ps_created_by = @ps_created_by
	END

return @ll_location_result_sequence
GO
GRANT EXECUTE
	ON [dbo].[sp_xml_add_observation_result]
	TO [cprsystem]
GO

