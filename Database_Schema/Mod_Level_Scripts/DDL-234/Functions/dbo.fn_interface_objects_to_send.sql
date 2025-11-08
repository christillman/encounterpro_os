
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_interface_objects_to_send]
Print 'Drop Function [dbo].[fn_interface_objects_to_send]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_interface_objects_to_send]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_interface_objects_to_send]
GO

-- Create Function [dbo].[fn_interface_objects_to_send]
Print 'Create Function [dbo].[fn_interface_objects_to_send]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_interface_objects_to_send (
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
	[office_id] varchar(4) NULL ,
	[office_user_id] varchar(255) NULL ,
	[id] [uniqueidentifier] NOT NULL
	)

AS

BEGIN


-- This is an indirect call to the UDF that gathers info about the document objects.  We do
-- this in case we decide later that the UDF called by document queries and the UDF used to consult
-- document objects should have different logic

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	office_user_id,
	id)
SELECT object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	office_user_id,
	id
FROM dbo.fn_document_objects(@pl_document_patient_workplan_item_id)


RETURN

END

GO
GRANT SELECT ON [dbo].[fn_interface_objects_to_send] TO [cprsystem]
GO

