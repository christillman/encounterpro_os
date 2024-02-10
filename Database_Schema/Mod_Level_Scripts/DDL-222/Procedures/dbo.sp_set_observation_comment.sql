
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_set_observation_comment]
Print 'Drop Procedure [dbo].[sp_set_observation_comment]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_observation_comment]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_observation_comment]
GO

-- Create Procedure [dbo].[sp_set_observation_comment]
Print 'Create Procedure [dbo].[sp_set_observation_comment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_observation_comment (
	@ps_cpr_id varchar(12),
	@pl_observation_sequence int,
	@ps_observation_id varchar(24),
	@ps_comment_type varchar(24),
	@ps_comment_title varchar(48) = NULL,
	@pdt_comment_date_time datetime = NULL,
	@ps_comment text = NULL,
	@ps_abnormal_flag char(1),
	@pi_severity smallint,
	@pl_treatment_id integer,
	@pl_encounter_id integer,
	@pl_attachment_id int = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ll_encounter_log_id integer,
	@li_encounter_count smallint,
	@ls_status varchar(12),
	@ll_patient_workplan_id int,
	@ls_in_office_flag char(1),
	@ls_short_comment varchar(40),
	@ll_length int


IF @ps_created_by IS NULL
	SET @ps_created_by = @ps_user_id

IF @pdt_comment_date_time IS NULL
	BEGIN
	-- If the comment_date_time is null then check to see if this user has a previous
	-- comment for this observation.  If so then assument that this comment updates the previous one
	SELECT @pdt_comment_date_time = max(comment_date_time)
	FROM p_Observation_Comment
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_observation_sequence
	AND comment_type = @ps_comment_type
	AND ISNULL(comment_title, '!NOTITLE') = ISNULL(@ps_comment_title, '!NOTITLE')
	AND [user_id] = @ps_user_id
	
	IF @pdt_comment_date_time IS NULL
		SET @pdt_comment_date_time = getdate()
	END

IF @ps_observation_id IS NULL OR @pl_treatment_id IS NULL
	SELECT @ps_observation_id = observation_id,
			@pl_treatment_id = treatment_id
	FROM p_Observation
	WHERE cpr_id = @ps_cpr_id
	AND observation_sequence = @pl_observation_sequence

-- First add the comment record.  If the length of @ps_comment is <= 40 then
-- store the value in [short_comment].  Otherwise store it in [comment].
SET @ll_length = LEN(CONVERT(varchar(255), @ps_comment))

IF @ll_length <= 40
	BEGIN
	SET @ls_short_comment = CONVERT(varchar(40), @ps_comment)

	INSERT INTO p_Observation_Comment (
		cpr_id,
		observation_sequence,
		observation_id,
		comment_date_time,
		comment_type,
		comment_title,
		short_comment,
		abnormal_flag,
		severity,
		treatment_id,
		encounter_id,
		attachment_id,
		user_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@ps_observation_id,
		@pdt_comment_date_time,
		@ps_comment_type,
		COALESCE(@ps_comment_title, 'Comment'),
		@ls_short_comment,
		@ps_abnormal_flag,
		@pi_severity,
		@pl_treatment_id,
		@pl_encounter_id,
		@pl_attachment_id,
		@ps_user_id,
		getdate(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_Observation_Comment (
		cpr_id,
		observation_sequence,
		observation_id,
		comment_date_time,
		comment_type,
		comment_title,
		comment,
		abnormal_flag,
		severity,
		treatment_id,
		encounter_id,
		attachment_id,
		user_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_observation_sequence,
		@ps_observation_id,
		@pdt_comment_date_time,
		@ps_comment_type,
		COALESCE(@ps_comment_title, 'Comment'),
		@ps_comment,
		@ps_abnormal_flag,
		@pi_severity,
		@pl_treatment_id,
		@pl_encounter_id,
		@pl_attachment_id,
		@ps_user_id,
		getdate(),
		@ps_created_by )

GO
GRANT EXECUTE
	ON [dbo].[sp_set_observation_comment]
	TO [cprsystem]
GO

