
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_set_report_attribute]
Print 'Drop Procedure [dbo].[sp_set_report_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_report_attribute]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_report_attribute]
GO

-- Create Procedure [dbo].[sp_set_report_attribute]
Print 'Create Procedure [dbo].[sp_set_report_attribute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.sp_set_report_attribute    Script Date: 7/25/2000 8:44:08 AM ******/
CREATE PROCEDURE dbo.sp_set_report_attribute (
	@pui_report_id varchar(40),
	@ps_attribute varchar(64),
	@ps_value varchar(255) = NULL,
	@ps_component_id varchar(40) = NULL)
AS

DECLARE @ls_component_attribute char(1),
		@ll_rowcount int,
		@ll_error int,
		@lui_component_id uniqueidentifier,
		@lui_report_id uniqueidentifier,
		@ll_attribute_sequence int

SET @lui_report_id = CAST(@pui_report_id AS uniqueidentifier)

IF @ps_component_id IS NULL
	BEGIN
	SET @ls_component_attribute = 'N'
	SET @lui_component_id = NULL
	END
ELSE
	BEGIN
	SET @ls_component_attribute = 'Y'

	-- If the length is greater than 24 then assume it's already the component guid
	
	IF LEN(@ps_component_id) > 24
		BEGIN
		SET @lui_component_id = CAST(@ps_component_id AS uniqueidentifier)
		SELECT @ll_error = @@ERROR
		IF @ll_error <> 0
			RETURN
		END
	ELSE
		BEGIN
		SELECT @lui_component_id = id
		FROM c_Component_Registry
		WHERE component_id = @ps_component_id

		IF @@ERROR <> 0
			RETURN

		IF @lui_component_id IS NULL
			BEGIN
			RAISERROR ('Cannot find component (%s)',16,-1, @ps_component_id)
			RETURN 0
			END

		END

	END

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM c_Report_Attribute
WHERE report_id = @lui_report_id
AND attribute = @ps_attribute
AND (component_id = @lui_component_id
	OR (component_id IS NULL AND @lui_component_id IS NULL)
	)

IF @@ERROR <> 0
	RETURN -1

IF @ll_attribute_sequence IS NULL
	BEGIN
	INSERT INTO c_Report_Attribute (
		report_id,
		attribute,
		value,
		component_attribute,
		component_id)
	VALUES (
		@lui_report_id,
		@ps_attribute,
		@ps_value,
		@ls_component_attribute,
		@lui_component_id)

	SET @ll_attribute_sequence = SCOPE_IDENTITY()
	END
ELSE
	BEGIN
	UPDATE c_Report_Attribute
	SET value = @ps_value
	WHERE report_id = @lui_report_id
	AND attribute_sequence = @ll_attribute_sequence
	END

RETURN @ll_attribute_sequence

GO
GRANT EXECUTE
	ON [dbo].[sp_set_report_attribute]
	TO [cprsystem]
GO

