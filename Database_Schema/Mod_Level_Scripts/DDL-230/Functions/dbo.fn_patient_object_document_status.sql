
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_patient_object_document_status]
Print 'Drop Function [dbo].[fn_patient_object_document_status]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_patient_object_document_status]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_patient_object_document_status]
GO

-- Create Function [dbo].[fn_patient_object_document_status]
Print 'Create Function [dbo].[fn_patient_object_document_status]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION dbo.fn_patient_object_document_status (
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(50),
	@pl_object_key int )

RETURNS int

AS
BEGIN

DECLARE @ll_status int,
		@ll_sum int

--
-- Returns integer:
--		0 = No documents
--		1 = Documents, but all are sent or cancelled
--		2 = Documents, at least one has not been sent
--

DECLARE @docs_by_status TABLE (
	status varchar(12) NOT NULL,
	doc_count int NOT NULL)

IF @ps_context_object = 'Encounter'
	BEGIN
	INSERT INTO @docs_by_status (
		status,
		doc_count)
	SELECT status,
			count(*)
	FROM p_Patient_WP_Item
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_object_key
	AND item_type = 'Document'
	AND status IS NOT NULL
	GROUP BY status
	END

SELECT @ll_sum = SUM(doc_count)
FROM @docs_by_status
WHERE status IN ('Ordered', 'Created', 'Error')

IF @ll_sum > 0
	RETURN 2

SELECT @ll_sum = SUM(doc_count)
FROM @docs_by_status

IF @ll_sum > 0
	RETURN 1

RETURN 0

END
GO
GRANT EXECUTE
	ON [dbo].[fn_patient_object_document_status]
	TO [cprsystem]
GO

