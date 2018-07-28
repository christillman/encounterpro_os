CREATE PROCEDURE jmj_create_rtf_report (
	@ps_report_name varchar(80),
	@ps_context_object varchar(24)
	)
AS

DECLARE @ll_customer_id int,
		@ls_current_user varchar(24),
		@ll_display_script_id int,
		@lui_report_id uniqueidentifier,
		@ldt_last_updated datetime

IF @ps_report_name IS NULL
	BEGIN
	RAISERROR ('Null report description',16,-1)
	RETURN
	END

-- See if the report already exists.  If it was created in the last 5 seconds,
-- assume it was created successfully in this attempt.  We do this because the
-- powerbuilder ad-hoc query engine will execute the query once to find out it's
-- SQL syntax and the execute it again to get the results
SELECT @ldt_last_updated = max(last_updated)
FROM c_Report_Definition
WHERE description = @ps_report_name

IF @ldt_last_updated IS NOT NULL
	BEGIN
	IF @ldt_last_updated > DATEADD(second, -5, getdate())
		BEGIN
		SELECT 'New ' + @ps_context_object + ' Report - "' + @ps_report_name + '" Successfully Created'
		RETURN
		END
	ELSE
		BEGIN
		RAISERROR ('Report description already exists (%s)',16,-1, @ps_report_name)
		RETURN
		END
	END


SELECT @ll_customer_id = customer_id
FROM c_Database_Status

SET @lui_report_id = newid()

SET @ls_current_user = COALESCE(dbo.fn_current_epro_user(), '#SYSTEM')

BEGIN TRANSACTION

INSERT INTO c_Report_Definition (
	report_id,
	description,
	report_type,
	component_id,
	status,
	owner_id)
VALUES (
	@lui_report_id,
	@ps_report_name,
	@ps_context_object,
	'RPT_RTF',
	'OK',
	@ll_customer_id)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

INSERT INTO c_Display_Script (
	context_object,
	display_script,
	description,
	status,
	updated_by,
	owner_id)
VALUES (
	@ps_context_object,
	@ps_report_name,
	@ps_report_name,
	'OK',
	@ls_current_user,
	@ll_customer_id)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

SET @ll_display_script_id = SCOPE_IDENTITY()

INSERT INTO c_Report_Attribute (
	report_id,
	attribute,
	value)
VALUES (
	@lui_report_id,
	'display_script_id',
	CAST(@ll_display_script_id AS varchar(12))
	)

IF @@ERROR <> 0
	BEGIN
	ROllBACK TRANSACTION
	RETURN
	END

COMMIT TRANSACTION

SELECT 'New ' + @ps_context_object + ' Report - "' + @ps_report_name + '" Successfully Created'

