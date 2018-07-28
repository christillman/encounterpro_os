CREATE PROCEDURE jmj_new_report (
	@ps_description varchar(80) ,
	@ps_report_type varchar(24) ,
	@ps_report_category varchar(24) = NULL,
	@ps_component_id varchar(24) ,
	@ps_machine_component_id varchar(24) = NULL,
	@ps_created_by varchar(24) ,
	@pl_owner_id int = NULL ,
	@ps_status varchar(12) ,
	@ps_long_description text = NULL ,
	@pl_version int = NULL ,
	@ps_report_id varchar(36) OUTPUT )
AS

DECLARE @ll_return int

SET @ll_return = 1

SET @ps_report_id = CAST(newid() AS varchar(36))

IF @pl_owner_id IS NULL
	SELECT @pl_owner_id = customer_id
	FROM c_Database_Status

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @pl_version IS NULL
	SET @pl_version = 1

INSERT INTO c_Report_Definition (
	report_id,
	description,
	report_type,
	report_category,
	component_id,
	status,
	owner_id,
	last_updated,
	id,
	machine_component_id,
	long_description,
	version )
VALUES (
	@ps_report_id,
	@ps_description,
	@ps_report_type,
	@ps_report_category,
	@ps_component_id,
	@ps_status,
	@pl_owner_id,
	getdate(),
	newid(),
	@ps_machine_component_id,
	@ps_long_description,
	@pl_version )

IF @@ERROR <> 0
	SET @ll_return = -1

RETURN @ll_return

