CREATE FUNCTION fn_interface_objects_to_send_sample (
	@pl_document_patient_workplan_item_id int
	)

RETURNS @objects TABLE (
	[object_sequence] [int] NOT NULL,
	[cpr_id] [varchar](12) NOT NULL,
	[context_object] [varchar] (24) NOT NULL,
	[object_key] [int] NOT NULL,
	[object_date] [datetime] NOT NULL,
	[object_type] [varchar] (24) NOT NULL ,
	[object_description] [varchar] (80) NOT NULL ,
	[object_status] [varchar] (12) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL
	)

AS

BEGIN


INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	id)
SELECT TOP 2 object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	id
FROM dbo.fn_document_objects(@pl_document_patient_workplan_item_id)

RETURN

END

