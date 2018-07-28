CREATE FUNCTION dbo.fn_count_documents_for_object (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int,
	@pdt_begin_date datetime,
	@pdt_end_date datetime)

RETURNS @documents TABLE (
	ready_count int NOT NULL,
	total_count int NOT NULL,  -- Not including cancelled
	cancelled_count int NOT NULL,
	incoming_count int NOT NULL)

AS
BEGIN
DECLARE @docs TABLE (
	patient_workplan_item_id int NOT NULL,
	status varchar(12) NULL)

INSERT INTO @docs (
	patient_workplan_item_id,
	status)
SELECT patient_workplan_item_id,
	status
FROM dbo.fn_documents_for_object_2(@ps_context_object, @ps_cpr_id, @pl_object_key, @pdt_begin_date, @pdt_end_date)

INSERT INTO @documents (
	ready_count,
	total_count,
	cancelled_count,
	incoming_count )
SELECT count(*), 0, 0, 0
FROM @docs
WHERE status IN ('Ordered', 'Created')

UPDATE @documents
SET total_count = (SELECT count(*) FROM @docs WHERE status <> 'Cancelled')

UPDATE @documents
SET cancelled_count = (SELECT count(*) FROM @docs WHERE status = 'Cancelled')

UPDATE @documents
SET incoming_count = (SELECT count(*) FROM dbo.fn_incoming_documents_for_context(@ps_context_object, @ps_cpr_id, @pl_object_key))


RETURN

END
