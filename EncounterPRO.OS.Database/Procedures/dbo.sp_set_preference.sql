
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_set_preference]
Print 'Drop Procedure [dbo].[sp_set_preference]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_preference]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_preference]
GO

-- Create Procedure [dbo].[sp_set_preference]
Print 'Create Procedure [dbo].[sp_set_preference]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_set_preference (
	@ps_preference_type varchar(24) = NULL,
	@ps_preference_level varchar(12),
	@ps_preference_key varchar(40),
	@ps_preference_id varchar(40),
	@ps_preference_value varchar(255) )
AS

IF @ps_preference_level = 'Global'
	SET @ps_preference_key = 'Global'

IF @ps_preference_type IS NULL
	SELECT @ps_preference_type = preference_type
	FROM c_Preference
	WHERE preference_id = @ps_preference_id

IF @ps_preference_value IS NULL
	BEGIN
	DELETE o_Preferences
	WHERE preference_type = @ps_preference_type
	AND   preference_level = @ps_preference_level
	AND   preference_key = @ps_preference_key
	AND   preference_id = @ps_preference_id
	END
ELSE
	BEGIN
	UPDATE o_Preferences
	SET preference_value = @ps_preference_value
	WHERE preference_type = @ps_preference_type
	AND   preference_level = @ps_preference_level
	AND   preference_key = @ps_preference_key
	AND   preference_id = @ps_preference_id

	IF @@ROWCOUNT <> 1
		BEGIN
		INSERT INTO o_Preferences (
			preference_type,
			preference_level,
			preference_key,
			preference_id,
			preference_value)
		VALUES (
			@ps_preference_type,
			@ps_preference_level,
			@ps_preference_key,
			@ps_preference_id,
			@ps_preference_value)
		END
	END

GO
GRANT EXECUTE
	ON [dbo].[sp_set_preference]
	TO [cprsystem]
GO

