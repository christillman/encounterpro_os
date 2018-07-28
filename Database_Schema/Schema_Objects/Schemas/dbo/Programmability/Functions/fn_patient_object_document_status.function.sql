CREATE FUNCTION fn_patient_object_document_status (
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
