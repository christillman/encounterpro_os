
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_get_document_dispatch_methods]
Print 'Drop Procedure [dbo].[jmj_get_document_dispatch_methods]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_get_document_dispatch_methods]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_get_document_dispatch_methods]
GO

-- Create Procedure [dbo].[jmj_get_document_dispatch_methods]
Print 'Create Procedure [dbo].[jmj_get_document_dispatch_methods]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_get_document_dispatch_methods (
	@ps_report_id varchar(40),
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24),
	@ps_purpose varchar(40),
	@ps_cpr_id varchar(12) = NULL)
AS

DECLARE @lui_report_id uniqueidentifier,
	@ll_error int,
	@ll_rowcount int,
	@ll_ordered_by_actor_id int,
	@ll_ordered_for_actor_id int


IF @ps_ordered_for IS NULL
	BEGIN
	RAISERROR ('ordered_for cannot be null',16,-1)
	RETURN -1
	END

SELECT @ll_ordered_by_actor_id = @ll_ordered_by_actor_id
FROM c_User
WHERE [user_id] = @ps_ordered_by

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('ordered_by not found (%s)',16,-1, @ps_ordered_by)
	RETURN -1
	END

SELECT @ll_ordered_for_actor_id = @ll_ordered_for_actor_id
FROM c_User
WHERE [user_id] = @ps_ordered_for

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount = 0
	BEGIN
	RAISERROR ('ordered_for not found (%s)',16,-1, @ps_ordered_for)
	RETURN -1
	END


SELECT DISTINCT cr.document_route, selected_flag=0
FROM dbo.fn_document_available_routes_2(@ps_ordered_by, @ps_ordered_for, @ps_purpose, @ps_cpr_id, @ps_report_id) cr
WHERE cr.is_valid = 1


GO
GRANT EXECUTE
	ON [dbo].[jmj_get_document_dispatch_methods]
	TO [cprsystem]
GO

