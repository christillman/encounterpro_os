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

-- Drop Procedure [dbo].[sp_add_workplan_item_attribute]
Print 'Drop Procedure [dbo].[sp_add_workplan_item_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_add_workplan_item_attribute]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_add_workplan_item_attribute]
GO

-- Create Procedure [dbo].[sp_add_workplan_item_attribute]
Print 'Create Procedure [dbo].[sp_add_workplan_item_attribute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_add_workplan_item_attribute
	(
	@ps_cpr_id varchar(12) = NULL,
	@pl_patient_workplan_id int = NULL,
	@pl_patient_workplan_item_id int,
	@ps_attribute varchar(64),
	@ps_value text = NULL,
	@ps_created_by varchar(24),
	@ps_user_id varchar(24) = NULL,
	@pdt_created datetime = NULL
	)
AS

DECLARE @ll_length int,
	@ls_value_short varchar(50),
	@ll_actor_id int

IF @ps_user_id IS NULL
	SET @ps_user_id = @ps_created_by

SELECT @ll_actor_id = actor_id
FROM c_User
WHERE user_id = @ps_user_id

IF @pdt_created IS NULL
	SET @pdt_created = getdate()

IF (@ps_cpr_id IS NULL) OR (@pl_patient_workplan_id IS NULL)
	BEGIN
	SELECT @ps_cpr_id = cpr_id,
		@pl_patient_workplan_id = patient_workplan_id
	FROM p_Patient_WP_Item
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

	IF @@rowcount <> 1
		BEGIN
		RAISERROR ('No such workplan item (%d)',16,-1, @pl_patient_workplan_item_id)
		ROLLBACK TRANSACTION
		RETURN
		END
	END


-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].
SELECT @ll_length = LEN(CONVERT(varchar(500), @ps_value))

IF @ll_length <= 50
	BEGIN
	SELECT @ls_value_short = CONVERT(varchar(50), @ps_value)

	INSERT INTO p_Patient_WP_Item_Attribute
		(
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	VALUES	(
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ps_attribute,
		@ls_value_short,
		@ll_actor_id,
		@ps_created_by,
		@pdt_created)
	END
ELSE
	BEGIN
	INSERT INTO p_Patient_WP_Item_Attribute
		(
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		attribute,
		message,
		actor_id,
		created_by,
		created)
	VALUES	(
		@ps_cpr_id,
		@pl_patient_workplan_id,
		@pl_patient_workplan_item_id,
		@ps_attribute,
		@ps_value,
		@ll_actor_id,
		@ps_created_by,
		@pdt_created)
	END

IF @@rowcount <> 1
	BEGIN
	RAISERROR ('Could not insert record into p_Patient_WP_Item_Attribute',16,-1)
	ROLLBACK TRANSACTION
	RETURN
	END


GO
GRANT EXECUTE
	ON [dbo].[sp_add_workplan_item_attribute]
	TO [cprsystem]
GO

