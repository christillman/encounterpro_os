
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_incoming_documents_for_context]
Print 'Drop Function [dbo].[fn_incoming_documents_for_context]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_incoming_documents_for_context]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_incoming_documents_for_context]
GO

-- Create Function [dbo].[fn_incoming_documents_for_context]
Print 'Create Function [dbo].[fn_incoming_documents_for_context]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_incoming_documents_for_context (
	@ps_context_object varchar(24),
	@ps_cpr_id varchar(12),
	@pl_object_key int
	)

RETURNS @documents TABLE (
	[attachment_id] [int] NOT NULL,
	[cpr_id] [varchar](12) NULL,
	[encounter_id] [int] NULL,
	[problem_id] [int] NULL,
	[treatment_id] [int] NULL,
	[observation_sequence] [int] NULL,
	[attachment_type] [varchar](24) NULL,
	[attachment_tag] [varchar](80) NULL,
	[attachment_file_path] [varchar](128) NULL,
	[attachment_file] [varchar](128) NULL,
	[extension] [varchar](24) NULL,
	[attachment_text] [nvarchar](max) NULL,
	[storage_flag] [char](1) NULL,
	[attachment_date] [datetime] NULL,
	[attachment_folder] [varchar](40) NULL,
	[box_id] [int] NULL,
	[item_id] [int] NULL,
	[attached_by] varchar(255) NULL,
	[created] [datetime] NULL ,
	[created_by] varchar(255) NULL,
	[status] [varchar](12) NULL ,
	[id] [uniqueidentifier] NOT NULL ,
	[context_object] [varchar](24) NULL,
	[object_key] [int] NULL,
	[default_grant] [bit] NOT NULL ,
	[interpreted] [bit] NOT NULL ,
	[failed_once] [bit] NOT NULL DEFAULT (0),
	[failed_mappings] [bit] NOT NULL DEFAULT (0),
	[owner_id] [int] NULL,
	[interfaceserviceid] [int] NULL,
	[interfacedescription] [varchar] (80) NULL
	)
AS
BEGIN

INSERT INTO @documents (
	attachment_id,   
	cpr_id,   
	encounter_id,   
	problem_id,   
	treatment_id,   
	observation_sequence,   
	attachment_type,   
	attachment_tag,   
	attachment_file_path,   
	attachment_file,   
	extension,   
	attachment_text,   
	storage_flag,   
	attachment_date,   
	attachment_folder,   
	box_id,   
	item_id,   
	attached_by,   
	created,   
	created_by,   
	status,   
	id,
	context_object,   
	object_key,   
	default_grant,   
	interpreted,
	owner_id,
	interfaceserviceid  )
SELECT p.attachment_id,   
     p.cpr_id,   
     p.encounter_id,   
     p.problem_id,   
     p.treatment_id,   
     p.observation_sequence,   
     p.attachment_type,   
     p.attachment_tag,   
     p.attachment_file_path,   
     p.attachment_file,   
     p.extension,   
     p.attachment_text,   
     p.storage_flag,   
     p.attachment_date,   
     p.attachment_folder,   
     p.box_id,   
     p.item_id,   
     p.attached_by,   
     p.created,   
     p.created_by,   
     p.status,   
     p.id,
     p.context_object,   
     p.object_key,   
     p.default_grant,   
     p.interpreted,
     p.owner_id,
	 p.interfaceserviceid
FROM p_Attachment p
WHERE p.context_object = @ps_context_object
AND p.cpr_id = @ps_cpr_id
AND p.object_key = @pl_object_key
AND p.status = 'OK'

UPDATE d
SET failed_once = 1
FROM @documents d
	INNER JOIN p_Attachment_Progress p
	ON d.attachment_id = p.attachment_id
WHERE p.progress_type = 'Failed Posting'
AND p.current_flag = 'Y'

UPDATE d
SET failed_mappings = 1
FROM @documents d
	INNER JOIN p_Attachment_Progress p
	ON d.attachment_id = p.attachment_id
WHERE p.progress_type = 'Failed Mappings'
AND p.current_flag = 'Y'

UPDATE d
SET interfaceserviceid = owner_id
FROM @documents d
WHERE d.interfaceserviceid = 0
AND d.owner_id <> 0
AND d.owner_id <> (SELECT customer_id FROM c_Database_Status)

UPDATE d
SET interfacedescription = i.interfacedescription
FROM @documents d
	INNER JOIN dbo.fn_practice_interfaces() i
	ON d.interfaceserviceid = i.interfaceserviceid

DELETE d
FROM @documents d
WHERE interfaceserviceid IS NULL OR interfaceserviceid <= 0

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_incoming_documents_for_context] TO [cprsystem]
GO

