
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_documents_for_object]
Print 'Drop Function [dbo].[fn_documents_for_object]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_documents_for_object]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_documents_for_object]
GO

-- Create Function [dbo].[fn_documents_for_object]
Print 'Create Function [dbo].[fn_documents_for_object]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_documents_for_object (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int)

RETURNS @documents TABLE (
	cpr_id varchar(12) NOT NULL,
	encounter_id int NOT NULL,
	patient_workplan_item_id int NOT NULL,
	ordered_by varchar(255) NOT NULL,
	actor_id int NULL,
	actor_class varchar(24) NULL,
	communication_type varchar(24) NULL,
	description varchar(80) NULL,
	ordered_for varchar(255) NULL,
	user_full_name varchar(64) NULL,
	dispatch_method varchar(24) NULL,
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12) NULL,
	display_status varchar(12) NULL,
	sent_status varchar(12) NULL,
	retries int NULL,
	escalation_date datetime NULL,
	expiration_date datetime NULL,
	report_id varchar(40) NULL,
	attachment_id int NULL,
	via_address varchar(255) NULL,
	via_address_display varchar(255) NULL,
	via_address_choices int NOT NULL DEFAULT 0,
	get_signature varchar(12) NOT NULL DEFAULT ('Optional'),
	get_ordered_for varchar(12) NOT NULL DEFAULT ('Optional'),
	material_id int NULL,
	document_type varchar(12) NULL,
	treatment_id int NULL,
	problem_id int NULL,
	document_context_object varchar(24) NULL,
	document_object_key int NULL,
	error_message varchar(255) NULL,
	purpose varchar(40) NULL)
AS
BEGIN

DECLARE @ldt_begin_date datetime,
		@ldt_end_date datetime

SET @ldt_begin_date = NULL
SET @ldt_end_date = NULL

INSERT INTO @documents (
	cpr_id ,
	encounter_id ,
	patient_workplan_item_id ,
	ordered_by ,
	actor_id ,
	actor_class ,
	communication_type ,
	description ,
	ordered_for ,
	user_full_name ,
	dispatch_method ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	display_status ,
	sent_status ,
	retries ,
	escalation_date ,
	expiration_date ,
	report_id ,
	attachment_id ,
	via_address ,
	via_address_display ,
	via_address_choices ,
	get_signature ,
	get_ordered_for ,
	material_id ,
	document_type ,
	treatment_id ,
	problem_id ,
	document_context_object ,
	document_object_key ,
	error_message ,
	purpose )
SELECT cpr_id ,
	encounter_id ,
	patient_workplan_item_id ,
	ordered_by ,
	actor_id ,
	actor_class ,
	communication_type ,
	description ,
	ordered_for ,
	user_full_name ,
	dispatch_method ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	display_status ,
	sent_status ,
	retries ,
	escalation_date ,
	expiration_date ,
	report_id ,
	attachment_id ,
	via_address ,
	via_address_display ,
	via_address_choices ,
	get_signature ,
	get_ordered_for ,
	material_id ,
	document_type ,
	treatment_id ,
	problem_id ,
	document_context_object ,
	document_object_key ,
	error_message ,
	purpose
FROM dbo.fn_documents_for_object_2(@ps_context_object, @ps_cpr_id, @pl_object_key, @ldt_begin_date, @ldt_end_date)

RETURN

END
GO
GRANT SELECT ON [dbo].[fn_documents_for_object] TO [cprsystem]
GO

