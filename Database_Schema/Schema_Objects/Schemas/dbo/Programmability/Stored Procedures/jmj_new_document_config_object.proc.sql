CREATE PROCEDURE jmj_new_document_config_object (
	@ps_config_object_type varchar(24) ,
	@ps_description varchar(80) ,
	@ps_context_object varchar(24) ,
	@ps_component_id varchar(24) ,
	@ps_created_by varchar(24) ,
	@ps_status varchar(12) ,
	@ps_long_description text = NULL ,
	@ps_report_id varchar(40) OUTPUT )
AS

DECLARE @ll_return int,
		@ll_owner_id int,
		@ls_report_component_id varchar(24),
		@ls_document_format varchar(24)

-- The report component for document config objects is always RPT_Document
SET @ls_report_component_id = 'RPT_Document'

SET @ll_return = 1

SET @ps_report_id = CAST(newid() AS varchar(40))

SELECT @ll_owner_id = customer_id
FROM c_Database_Status

SET @ls_document_format = 'Machine'

IF @ps_status IS NULL
	SET @ps_status = 'OK'

INSERT INTO c_Report_Definition (
	report_id,
	description,
	report_type,
	component_id,
	status,
	owner_id,
	last_updated,
	document_format,
	config_object_type,
	id,
	long_description)
VALUES (
	@ps_report_id,
	@ps_description,
	@ps_context_object,
	@ls_report_component_id,
	@ps_status,
	@ll_owner_id,
	getdate(),
	@ls_document_format,
	@ps_config_object_type,
	newid(),
	@ps_long_description )

IF @@ERROR <> 0
	RETURN -1


-- Now add the document component as an attribute to the report definition
INSERT INTO c_Report_Attribute (
	report_id,
	attribute,
	value,
	component_attribute,
	component_id)
SELECT @ps_report_id,
	'document_component_id',
	@ps_component_id,
	'Y',
	id
FROM c_Component_Registry
WHERE component_id = @ls_report_component_id

IF @@ERROR <> 0
	RETURN -1


RETURN 1

