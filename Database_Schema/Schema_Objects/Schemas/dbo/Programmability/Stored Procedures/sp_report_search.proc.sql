CREATE PROCEDURE sp_report_search (
	@ps_context_object varchar(24) = NULL,
	@ps_description varchar(40) = NULL,
	@ps_report_category varchar(24) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_document_format varchar(24) = 'Human' )
AS

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_report_category IS NULL
	SELECT @ps_report_category = '%'

IF @ps_context_object IS NULL
	SELECT @ps_context_object = '%'

SELECT report_id,
	report_type,
	report_category,
	description,
	component_id,
	status,
	selected_flag=0
FROM c_report_Definition
WHERE status like @ps_status
AND description like @ps_description
AND report_type like @ps_context_object
AND ISNULL(report_category, '') like @ps_report_category
AND document_format = @ps_document_format
