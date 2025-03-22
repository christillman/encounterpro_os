
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_interfaceserviceid]
Print 'Drop Function [dbo].[fn_document_interfaceserviceid]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_interfaceserviceid]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_interfaceserviceid]
GO

-- Create Function [dbo].[fn_document_interfaceserviceid]
Print 'Create Function [dbo].[fn_document_interfaceserviceid]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_document_interfaceserviceid (
	@pl_document_patient_workplan_item_id int)

RETURNS int

AS
BEGIN
DECLARE @ll_interfaceserviceid int,
		@ls_document_route varchar(24),
		@ls_ordered_for varchar(24),
		@ls_ordered_by varchar(24),
		@ls_property varchar(255)

SELECT @ls_document_route = dispatch_method,
		@ls_ordered_for = ordered_for,
		@ls_ordered_by = ordered_by

FROM dbo.p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_document_patient_workplan_item_id

IF @@ERROR <> 0
	RETURN -1

IF @ls_ordered_by IS NULL
	RETURN -1

-- First see if route has a send_via_addressee
SELECT @ll_interfaceserviceid = send_via_addressee
FROM dbo.c_Document_Route
WHERE document_route = @ls_document_route

IF @@ERROR <> 0
	RETURN -1

IF @ll_interfaceserviceid <> 0
	RETURN @ll_interfaceserviceid

SET @ll_interfaceserviceid = NULL

-- Then see if the recipient has an interfaceserviceid
IF @ls_ordered_for IS NULL
	RETURN @ll_interfaceserviceid

SET @ls_property = dbo.fn_user_property(@ls_ordered_for, 'Property', 'InterfaceServiceID')
IF ISNUMERIC(@ls_property) = 1
	SET @ll_interfaceserviceid = CAST(@ls_property AS int)

RETURN @ll_interfaceserviceid 

END
GO
GRANT EXECUTE
	ON [dbo].[fn_document_interfaceserviceid]
	TO [cprsystem]
GO

