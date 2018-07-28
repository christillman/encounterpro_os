CREATE PROCEDURE [dbo].[jmj_upload_params] (
	@pui_id varchar(40) )
AS

DECLARE @ll_count int,
		@ll_error int,
		@ls_status varchar(12),
		@ls_config_object_id varchar(38),
		@lui_batch_id uniqueidentifier,
		@ldt_batch_date datetime,
		@lui_id uniqueidentifier 

SET @lui_id = CAST(@pui_id AS uniqueidentifier)

SET NOCOUNT ON

IF @lui_id IS NULL
	BEGIN
	RAISERROR ('id cannot be null',16,-1)
	RETURN -2
	END

SET @lui_batch_id = newid()
SET @ldt_batch_date = getdate()

-- First save the existing records
DECLARE @params TABLE (
	[id] [uniqueidentifier] NOT NULL,
	[param_sequence] [int] NOT NULL,
	[param_class] [varchar](40) NOT NULL,
	[param_mode] [varchar](12) NULL,
	[sort_sequence] [smallint] NULL,
	[param_title] [varchar](80) NULL,
	[token1] [varchar](40) NULL,
	[token2] [varchar](40) NULL,
	[token3] [varchar](40) NULL,
	[token4] [varchar](40) NULL,
	[initial1] [varchar](128) NULL,
	[initial2] [varchar](128) NULL,
	[initial3] [varchar](128) NULL,
	[initial4] [varchar](128) NULL,
	[required_flag] [char](1) NULL,
	[helptext] [text] NULL,
	[query] [text] NULL,
	[min_build] [varchar](12) NULL,
	[last_updated] [datetime] NOT NULL,
	[param_id] [uniqueidentifier] NOT NULL
) 

INSERT INTO @params
           ([id]
			,[param_sequence]
			,[param_class]
			,[param_mode]
			,[sort_sequence]
			,[param_title]
			,[token1]
			,[token2]
			,[token3]
			,[token4]
			,[initial1]
			,[initial2]
			,[initial3]
			,[initial4]
			,[required_flag]
			,[helptext]
			,[query]
			,[min_build]
			,[last_updated]
			,[param_id])
SELECT		[id]
			,[param_sequence]
			,[param_class]
			,[param_mode]
			,[sort_sequence]
			,[param_title]
			,[token1]
			,[token2]
			,[token3]
			,[token4]
			,[initial1]
			,[initial2]
			,[initial3]
			,[initial4]
			,[required_flag]
			,[helptext]
			,[query]
			,[min_build]
			,[last_updated]
			,[param_id]
FROM jmjtech.eproupdates.dbo.c_Component_Param
WHERE id = @lui_id

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -2

INSERT INTO jmjtech.eproupdates.dbo.c_Component_Param_Save
           (batch_id
			,batch_date
			,[id]
			,[param_sequence]
			,[param_class]
			,[param_mode]
			,[sort_sequence]
			,[param_title]
			,[token1]
			,[token2]
			,[token3]
			,[token4]
			,[initial1]
			,[initial2]
			,[initial3]
			,[initial4]
			,[required_flag]
			,[helptext]
			,[query]
			,[min_build]
			,[last_updated]
			,[param_id])
SELECT		@lui_batch_id
			,@ldt_batch_date
			,[id]
			,[param_sequence]
			,[param_class]
			,[param_mode]
			,[sort_sequence]
			,[param_title]
			,[token1]
			,[token2]
			,[token3]
			,[token4]
			,[initial1]
			,[initial2]
			,[initial3]
			,[initial4]
			,[required_flag]
			,[helptext]
			,[query]
			,[min_build]
			,[last_updated]
			,[param_id]
FROM @params

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -2


DELETE FROM jmjtech.eproupdates.dbo.c_Component_Param
WHERE id = @lui_id

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -2

INSERT INTO jmjtech.eproupdates.dbo.c_Component_Param
           ([id]
           ,[param_class]
           ,[param_mode]
           ,[sort_sequence]
           ,[param_title]
           ,[token1]
           ,[token2]
           ,[token3]
           ,[token4]
           ,[initial1]
           ,[initial2]
           ,[initial3]
           ,[initial4]
           ,[required_flag]
           ,[helptext]
           ,[query]
           ,[min_build]
           ,[last_updated]
           ,[param_id])
SELECT		[id]
           ,[param_class]
           ,[param_mode]
           ,[sort_sequence]
           ,[param_title]
           ,[token1]
           ,[token2]
           ,[token3]
           ,[token4]
           ,[initial1]
           ,[initial2]
           ,[initial3]
           ,[initial4]
           ,[required_flag]
           ,[helptext]
           ,[query]
           ,[min_build]
           ,[last_updated]
           ,[param_id]
FROM c_Component_Param
WHERE id = @lui_id

SELECT @ll_count = @@ROWCOUNT,
		@ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -2

RETURN 1

