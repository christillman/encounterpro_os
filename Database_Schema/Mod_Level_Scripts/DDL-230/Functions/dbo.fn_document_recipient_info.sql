﻿
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_recipient_info]
Print 'Drop Function [dbo].[fn_document_recipient_info]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_recipient_info]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_recipient_info]
GO

-- Create Function [dbo].[fn_document_recipient_info]
Print 'Create Function [dbo].[fn_document_recipient_info]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_document_recipient_info (
	@ps_ordered_for varchar(24),
	@ps_cpr_id varchar(12) = NULL,
	@pl_encounter_id int = NULL)

RETURNS @recipient TABLE (
	user_id varchar(24) NOT NULL,
	actor_class varchar(24) NOT NULL,
	actor_id int NULL,
	cpr_id varchar(24) NULL
	)
AS
BEGIN

DECLARE @ll_ordered_for_actor_id int,
	@ls_ordered_for_actor_class varchar(24),
	@ls_ordered_for_user_id varchar(24),
	@ls_ordered_for_cpr_id varchar(12)

SELECT @ll_ordered_for_actor_id = actor_id,
		@ls_ordered_for_actor_class = actor_class
FROM c_User
WHERE [user_id] = @ps_ordered_for

IF @@ERROR <> 0
	RETURN

-- If the ordered_for wasn't a user then see if it's an actor_class
IF @ll_ordered_for_actor_id IS NULL
	BEGIN
	SELECT @ll_ordered_for_actor_id = NULL,
			@ls_ordered_for_actor_class = actor_class
	FROM c_Actor_Class
	WHERE actor_class = @ps_ordered_for

	IF @@ERROR <> 0
		RETURN
	END

-- If the ordered_for_actor_class is "Special" 
IF @ls_ordered_for_actor_class = 'Special'
	BEGIN
	SET @ls_ordered_for_user_id = dbo.fn_special_user_resolution(@ps_ordered_for, @ps_cpr_id, @pl_encounter_id)
	IF @ls_ordered_for_user_id IS NULL
		SET @ls_ordered_for_user_id = @ps_ordered_for
	END
ELSE IF @ps_ordered_for = '#PATIENT'
	BEGIN
	-- Since the special user #PATIENT still has an actor_class 'Patient', we need to check specifically for it
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_user_id = '##' + @ps_cpr_id
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = @ps_cpr_id
	END
ELSE
	SET @ls_ordered_for_user_id = @ps_ordered_for


-- If the ordered_for_user_id looks like a patient, then get the ordered_for_cpr_id
IF LEFT(@ls_ordered_for_user_id, 2) = '##' -- Patient
	BEGIN
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = SUBSTRING(@ls_ordered_for_user_id, 3, 12)
	END
ELSE IF @ls_ordered_for_user_id <> @ps_ordered_for
	BEGIN
	-- The ordered_for_user_id has been resolved to something other than @ps_ordered_for, so reselect the actor class
	SELECT @ll_ordered_for_actor_id = actor_id,
			@ls_ordered_for_actor_class = actor_class
	FROM c_User
	WHERE [user_id] = @ls_ordered_for_user_id

	IF @@ERROR <> 0
		RETURN
	END

IF @ls_ordered_for_user_id IS NOT NULL
	INSERT INTO @recipient (
		user_id ,
		actor_class ,
		actor_id ,
		cpr_id)
	VALUES (
		@ls_ordered_for_user_id,
		@ls_ordered_for_actor_class,
		@ll_ordered_for_actor_id,
		@ls_ordered_for_cpr_id
		)

RETURN
END
GO
GRANT SELECT ON [dbo].[fn_document_recipient_info] TO [cprsystem]
GO

