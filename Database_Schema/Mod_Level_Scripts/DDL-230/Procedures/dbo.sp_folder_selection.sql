
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_folder_selection]
Print 'Drop Procedure [dbo].[sp_folder_selection]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_folder_selection]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_folder_selection]
GO

-- Create Procedure [dbo].[sp_folder_selection]
Print 'Create Procedure [dbo].[sp_folder_selection]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE sp_folder_selection (
	@ps_context_object varchar(24) = NULL,
	@ps_context_object_type varchar(40) = NULL,
	@ps_attachment_type varchar(24) = NULL,
	@ps_extension varchar(24) = NULL )
AS

DECLARE @folders TABLE (
	folder varchar(40) NOT NULL,
	context_object varchar(24) NOT NULL,
	context_object_type varchar(24) NULL,
	description varchar(255) NULL,
	status varchar(12) NOT NULL,
	workplan_required_flag char(1) NOT NULL,
	sort_sequence int NULL,
	auto_select_flag char(1) NOT NULL,
	selected_flag int NOT NULL)

INSERT INTO @folders (
	folder,
	context_object,
	context_object_type,
	description,
	status,
	workplan_required_flag,
	sort_sequence,
	auto_select_flag,
	selected_flag )
SELECT f.folder,
	f.context_object,
	f.context_object_type,
	f.description,
	f.status,
	f.workplan_required_flag,
	min(s.sort_sequence) as sort_sequence,
	max(s.auto_select_flag) as auto_select_flag,
	max(0) as selected_flag
FROM c_Folder f
	INNER JOIN c_Folder_Selection s
	ON f.folder = s.folder
WHERE s.context_object = @ps_context_object
AND (s.context_object_type IS NULL OR s.context_object_type = @ps_context_object_type)
AND (s.attachment_type IS NULL OR s.attachment_type = @ps_attachment_type)
AND (s.extension IS NULL OR s.extension = @ps_extension)
AND (f.status = 'OK' OR s.auto_select_flag = 'Y')
GROUP BY f.folder,
	f.context_object,
	f.context_object_type,
	f.description,
	f.status,
	f.workplan_required_flag

-- If we didn't find any, the show the associated folders, but don't show anything for signatures
IF @@ROWCOUNT = 0 AND @ps_attachment_type <> 'SIGNATURE'
	IF @ps_context_object = 'Patient'
		INSERT INTO @folders (
			folder,
			context_object,
			context_object_type,
			description,
			status,
			workplan_required_flag,
			sort_sequence,
			auto_select_flag,
			selected_flag )
		SELECT f.folder,
			f.context_object,
			f.context_object_type,
			f.description,
			f.status,
			f.workplan_required_flag,
			f.sort_sequence,
			'N' as auto_select_flag,
			0 as selected_flag
		FROM c_Folder f
		WHERE f.status = 'OK'
	ELSE
		INSERT INTO @folders (
			folder,
			context_object,
			context_object_type,
			description,
			status,
			workplan_required_flag,
			sort_sequence,
			auto_select_flag,
			selected_flag )
		SELECT f.folder,
			f.context_object,
			f.context_object_type,
			f.description,
			f.status,
			f.workplan_required_flag,
			f.sort_sequence,
			'N' as auto_select_flag,
			0 as selected_flag
		FROM c_Folder f
		WHERE f.status = 'OK'
		AND f.context_object = @ps_context_object
		AND ISNULL(f.context_object_type, @ps_context_object_type) = @ps_context_object_type

-- Get the folders as a result set
SELECT folder,
	context_object,
	context_object_type,
	description,
	status,
	workplan_required_flag,
	sort_sequence,
	auto_select_flag,
	selected_flag
FROM @folders


GO
GRANT EXECUTE
	ON [dbo].[sp_folder_selection]
	TO [cprsystem]
GO

