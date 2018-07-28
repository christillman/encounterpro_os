CREATE FUNCTION fn_document_available_routes (
	@ps_ordered_by varchar(24),
	@ps_ordered_for varchar(24),
	@ps_purpose varchar(40),
	@ps_cpr_id varchar(12) = NULL)

RETURNS @routes TABLE (
	document_route varchar(24) NOT NULL,
	sort_sequence int NULL,
	document_format varchar(24) NOT NULL,
	communication_type varchar(24) NULL,
	sender_id_key varchar(40) NULL,
	receiver_id_key varchar(40) NULL,
	is_valid bit NOT NULL DEFAULT (1),
	invalid_help varchar(255) NULL
	)


AS
BEGIN

INSERT INTO @routes (
	document_route ,
	sort_sequence ,
	document_format ,
	communication_type ,
	sender_id_key ,
	receiver_id_key ,
	is_valid ,
	invalid_help )
SELECT document_route ,
	sort_sequence ,
	document_format ,
	communication_type ,
	sender_id_key ,
	receiver_id_key ,
	is_valid ,
	invalid_help
FROM dbo.fn_document_available_routes_2(@ps_ordered_by, @ps_ordered_for, @ps_purpose, @ps_cpr_id, DEFAULT)

RETURN
END
