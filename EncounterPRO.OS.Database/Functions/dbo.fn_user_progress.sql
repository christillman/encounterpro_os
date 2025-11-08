
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_user_progress]
Print 'Drop Function [dbo].[fn_user_progress]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_progress]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_progress]
GO

-- Create Function [dbo].[fn_user_progress]
Print 'Create Function [dbo].[fn_user_progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_user_progress (
	@ps_user_id varchar(255),
	@ps_progress_type varchar (24) = NULL ,
	@ps_progress_key varchar (40) = NULL )

RETURNS @progress TABLE (
	[user_id] [varchar](255) NOT NULL,
	[user_progress_sequence] [int] ,
	[progress_user_id] [varchar](24) NOT NULL,
	[progress_date_time] [datetime] NOT NULL,
	[progress_type] [varchar](24) NOT NULL,
	[progress_key] [varchar](40) NULL,
	[progress] [nvarchar](max) NULL,
	[created] [datetime] NOT NULL ,
	[created_by] [varchar](255) NOT NULL
)

AS

BEGIN


-- Patient Progress
INSERT INTO @progress (	
	[user_id] ,
	[user_progress_sequence] ,
	[progress_user_id] ,
	[progress_date_time] ,
	[progress_type] ,
	[progress_key] ,
	[progress] ,
	[created] ,
	[created_by] )
SELECT 
	p.user_id ,
	p.user_progress_sequence ,
	p.progress_user_id ,
	p.progress_date_time ,
	p.progress_type ,
	p.progress_key ,
	COALESCE(CAST(p.progress_value AS nvarchar(max)), p.progress) ,
	p.created ,
	p.created_by 
FROM c_User_Progress p
WHERE p.user_id = @ps_user_id
AND (@ps_progress_type IS NULL OR p.progress_type = @ps_progress_type)
AND (@ps_progress_key IS NULL OR p.progress_key = @ps_progress_key)
AND p.current_flag = 'Y'

RETURN
END

GO
GRANT SELECT ON [dbo].[fn_user_progress] TO [cprsystem]
GO

