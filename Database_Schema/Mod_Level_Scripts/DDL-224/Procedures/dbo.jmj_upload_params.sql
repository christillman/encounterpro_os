--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_upload_params]
Print 'Drop Procedure [dbo].[jmj_upload_params]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_upload_params]') AND [type]='P'))
DROP PROCEDURE IF EXISTS [dbo].[jmj_upload_params]
GO

-- Create Procedure [dbo].[jmj_upload_params]
Print 'Create Procedure [dbo].[jmj_upload_params]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[jmj_upload_params] (
	@pui_id varchar(40) )
AS

--DECLARE @ll_count int,
--		@ll_error int,
--		@ls_status varchar(12),
--		@ls_config_object_id varchar(38),
--		@lui_batch_id uniqueidentifier,
--		@ldt_batch_date datetime,
--		@lui_id uniqueidentifier 

--SET @lui_id = CAST(@pui_id AS uniqueidentifier)

--SET NOCOUNT ON

--IF @lui_id IS NULL
--	BEGIN
--	RAISERROR ('id cannot be null',16,-1)
--	RETURN -2
--	END

--SET @lui_batch_id = newid()
--SET @ldt_batch_date = getdate()

---- First save the existing records
--DECLARE @params TABLE (
--	[id] [uniqueidentifier] NOT NULL,
--	[param_sequence] [int] NOT NULL,
--	[param_class] [varchar](40) NOT NULL,
--	[param_mode] [varchar](12) NULL,
--	[sort_sequence] [smallint] NULL,
--	[param_title] [varchar](80) NULL,
--	[token1] [varchar](40) NULL,
--	[token2] [varchar](40) NULL,
--	[token3] [varchar](40) NULL,
--	[token4] [varchar](40) NULL,
--	[initial1] [varchar](128) NULL,
--	[initial2] [varchar](128) NULL,
--	[initial3] [varchar](128) NULL,
--	[initial4] [varchar](128) NULL,
--	[required_flag] [char](1) NULL,
--	[helptext] [text] NULL,
--	[query] [text] NULL,
--	[min_build] [varchar](12) NULL,
--	[last_updated] [datetime] NOT NULL,
--	[param_id] [uniqueidentifier] NOT NULL
--) 

--INSERT INTO @params
--           ([id]
--			,[param_sequence]
--			,[param_class]
--			,[param_mode]
--			,[sort_sequence]
--			,[param_title]
--			,[token1]
--			,[token2]
--			,[token3]
--			,[token4]
--			,[initial1]
--			,[initial2]
--			,[initial3]
--			,[initial4]
--			,[required_flag]
--			,[helptext]
--			,[query]
--			,[min_build]
--			,[last_updated]
--			,[param_id])
--SELECT		[id]
--			,[param_sequence]
--			,[param_class]
--			,[param_mode]
--			,[sort_sequence]
--			,[param_title]
--			,[token1]
--			,[token2]
--			,[token3]
--			,[token4]
--			,[initial1]
--			,[initial2]
--			,[initial3]
--			,[initial4]
--			,[required_flag]
--			,[helptext]
--			,[query]
--			,[min_build]
--			,[last_updated]
--			,[param_id]
--FROM jmjtech.eproupdates.dbo.c_Component_Param
--WHERE id = @lui_id

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

--INSERT INTO jmjtech.eproupdates.dbo.c_Component_Param_Save
--           (batch_id
--			,batch_date
--			,[id]
--			,[param_sequence]
--			,[param_class]
--			,[param_mode]
--			,[sort_sequence]
--			,[param_title]
--			,[token1]
--			,[token2]
--			,[token3]
--			,[token4]
--			,[initial1]
--			,[initial2]
--			,[initial3]
--			,[initial4]
--			,[required_flag]
--			,[helptext]
--			,[query]
--			,[min_build]
--			,[last_updated]
--			,[param_id])
--SELECT		@lui_batch_id
--			,@ldt_batch_date
--			,[id]
--			,[param_sequence]
--			,[param_class]
--			,[param_mode]
--			,[sort_sequence]
--			,[param_title]
--			,[token1]
--			,[token2]
--			,[token3]
--			,[token4]
--			,[initial1]
--			,[initial2]
--			,[initial3]
--			,[initial4]
--			,[required_flag]
--			,[helptext]
--			,[query]
--			,[min_build]
--			,[last_updated]
--			,[param_id]
--FROM @params

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2


--DELETE FROM jmjtech.eproupdates.dbo.c_Component_Param
--WHERE id = @lui_id

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

--INSERT INTO jmjtech.eproupdates.dbo.c_Component_Param
--           ([id]
--           ,[param_class]
--           ,[param_mode]
--           ,[sort_sequence]
--           ,[param_title]
--           ,[token1]
--           ,[token2]
--           ,[token3]
--           ,[token4]
--           ,[initial1]
--           ,[initial2]
--           ,[initial3]
--           ,[initial4]
--           ,[required_flag]
--           ,[helptext]
--           ,[query]
--           ,[min_build]
--           ,[last_updated]
--           ,[param_id])
--SELECT		[id]
--           ,[param_class]
--           ,[param_mode]
--           ,[sort_sequence]
--           ,[param_title]
--           ,[token1]
--           ,[token2]
--           ,[token3]
--           ,[token4]
--           ,[initial1]
--           ,[initial2]
--           ,[initial3]
--           ,[initial4]
--           ,[required_flag]
--           ,[helptext]
--           ,[query]
--           ,[min_build]
--           ,[last_updated]
--           ,[param_id]
--FROM c_Component_Param
--WHERE id = @lui_id

--SELECT @ll_count = @@ROWCOUNT,
--		@ll_error = @@ERROR

--IF @ll_error <> 0
--	RETURN -2

RETURN 1

GO
GRANT EXECUTE
	ON [dbo].[jmj_upload_params]
	TO [public]
GO

