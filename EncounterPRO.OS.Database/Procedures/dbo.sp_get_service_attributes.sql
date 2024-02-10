
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_service_attributes]
Print 'Drop Procedure [dbo].[sp_get_service_attributes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_service_attributes]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_service_attributes]
GO

-- Create Procedure [dbo].[sp_get_service_attributes]
Print 'Create Procedure [dbo].[sp_get_service_attributes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.sp_get_service_attributes (
	@ps_service varchar(24),
	@ps_user_id varchar(24) = NULL)
AS

DECLARE @ls_specialty_id varchar(24)

DECLARE  @tmpattribs TABLE
(	attribute_sequence int
)

-- First add the attributes where [user_id] is null
INSERT INTO @tmpattribs (attribute_sequence)
SELECT attribute_sequence
FROM o_Service_Attribute  
WHERE service = @ps_service
AND [user_id] IS NULL


SELECT @ls_specialty_id = COALESCE(specialty_id, '$')
FROM c_User
WHERE [user_id] = @ps_user_id

IF @@ROWCOUNT = 1
	BEGIN
	-- If we have a valid user_id, then add the specialty attributes followed by the user
	-- specific attributes
	INSERT INTO @tmpattribs (attribute_sequence)
	SELECT attribute_sequence
	FROM o_Service_Attribute  
	WHERE service = @ps_service
	AND [user_id] = @ls_specialty_id

	INSERT INTO @tmpattribs (attribute_sequence)
	SELECT attribute_sequence
	FROM o_Service_Attribute  
	WHERE service = @ps_service
	AND [user_id] = @ps_user_id
	END   

SELECT a.service,
	a.attribute_sequence,
	a.attribute,
	a.value
FROM o_Service_Attribute a
JOIN @tmpattribs t ON a.attribute_sequence = t.attribute_sequence
WHERE service = @ps_service

GO
GRANT EXECUTE
	ON [dbo].[sp_get_service_attributes]
	TO [cprsystem]
GO

