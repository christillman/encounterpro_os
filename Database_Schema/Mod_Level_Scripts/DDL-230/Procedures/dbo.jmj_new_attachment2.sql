
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_new_attachment2]
Print 'Drop Procedure [dbo].[jmj_new_attachment2]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_new_attachment2]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_new_attachment2]
GO

-- Create Procedure [dbo].[jmj_new_attachment2]
Print 'Create Procedure [dbo].[jmj_new_attachment2]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmj_new_attachment2 (
	@ps_description varchar(80),
	@ps_attachment_file varchar(128),
	@ps_extension varchar(24),
	@pl_owner_id int = NULL,
	@pl_box_id int = NULL,
	@pl_item_id int = NULL,
	@pl_interfaceserviceid int,
	@pl_transportsequence int,
	@pl_patient_workplan_item_id int,
	@ps_attached_by varchar(24),
	@ps_created_by varchar(24),
	@ps_id varchar(40) = NULL )
AS

-- This procedure creates an empty attachment record and returns the attachment_id to the caller.
-- The caller should post the attachment binary into the attachment_image column, and then 
-- call the stored procedure "jmj_set_incoming_attachment_ready"

DECLARE @ll_attachment_id int,
		@luo_id uniqueidentifier

IF @ps_id IS NULL
	SET @luo_id = newid()
ELSE
	SET @luo_id = CAST(@ps_id AS uniqueidentifier)


INSERT INTO p_Attachment (
	attachment_tag ,
	attachment_file ,
	extension ,
	owner_id ,
	box_id ,
	item_id ,
	interfaceserviceid ,
	transportsequence ,
	patient_workplan_item_id ,
	status ,
	attachment_date,
	storage_flag,
	attached_by ,
	created_by,
	id )
VALUES (
	@ps_description ,
	@ps_attachment_file ,
	@ps_extension ,
	@pl_owner_id ,
	@pl_box_id ,
	@pl_item_id ,
	@pl_interfaceserviceid ,
	@pl_transportsequence ,
	@pl_patient_workplan_item_id ,
	'New',
	dbo.get_client_datetime(),
	'D',
	@ps_attached_by ,
	@ps_created_by,
	@luo_id )

IF @@ERROR <> 0
	RETURN -1

SET @ll_attachment_id = SCOPE_IDENTITY()

RETURN @ll_attachment_id


GO
GRANT EXECUTE
	ON [dbo].[jmj_new_attachment2]
	TO [cprsystem]
GO

