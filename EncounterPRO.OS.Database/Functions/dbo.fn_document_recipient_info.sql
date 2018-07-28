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

-- Drop Function [dbo].[fn_document_recipient_info]
Print 'Drop Function [dbo].[fn_document_recipient_info]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_recipient_info]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_recipient_info]
GO

-- Create Function [dbo].[fn_document_recipient_info]
Print 'Create Function [dbo].[fn_document_recipient_info]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_document_recipient_info (
	@ps_ordered_for varchar(24),
	@ps_cpr_id varchar(12) = NULL,
	@pl_encounter_id int = NULL)

RETURNS @recipient TABLE (
	user_id varchar(24) NOT NULL,
	actor_class varchar(24) NOT NULL,
	actor_id int NULL,
	cpr_id varchar(24) NULL
	)
AS
BEGIN

DECLARE @ll_error int,
	@ll_rowcount int,
	@ll_ordered_for_actor_id int,
	@ls_ordered_for_actor_class varchar(24),
	@ls_ordered_for_user_id varchar(24),
	@ls_ordered_for_cpr_id varchar(12)

SELECT @ll_ordered_for_actor_id = actor_id,
		@ls_ordered_for_actor_class = actor_class
FROM c_User
WHERE user_id = @ps_ordered_for

SELECT @ll_error = @@ERROR,
	@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

-- If the ordered_for wasn't a user then see if it's an actor_class
IF @ll_rowcount = 0
	BEGIN
	SELECT @ll_ordered_for_actor_id = NULL,
			@ls_ordered_for_actor_class = actor_class
	FROM c_Actor_Class
	WHERE actor_class = @ps_ordered_for

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN

	IF @ll_rowcount = 0
		BEGIN
		SET @ll_ordered_for_actor_id = NULL
		SET @ls_ordered_for_actor_class = NULL
		END
	END

-- If the ordered_for_actor_class is "Special" 
IF @ls_ordered_for_actor_class = 'Special'
	BEGIN
	SET @ls_ordered_for_user_id = dbo.fn_special_user_resolution(@ps_ordered_for, @ps_cpr_id, @pl_encounter_id)
	IF @ls_ordered_for_user_id IS NULL
		SET @ls_ordered_for_user_id = @ps_ordered_for
	END
ELSE IF @ps_ordered_for = '#PATIENT'
	BEGIN
	-- Since the special user #PATIENT still has an actor_class 'Patient', we need to check specifically for it
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_user_id = '##' + @ps_cpr_id
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = @ps_cpr_id
	END
ELSE
	SET @ls_ordered_for_user_id = @ps_ordered_for


-- If the ordered_for_user_id looks like a patient, then get the ordered_for_cpr_id
IF LEFT(@ls_ordered_for_user_id, 2) = '##' -- Patient
	BEGIN
	SET @ll_ordered_for_actor_id = NULL
	SET @ls_ordered_for_actor_class = 'Patient'
	SET @ls_ordered_for_cpr_id = SUBSTRING(@ls_ordered_for_user_id, 3, 12)
	END
ELSE IF @ls_ordered_for_user_id <> @ps_ordered_for
	BEGIN
	-- The ordered_for_user_id has been resolved to something other than @ps_ordered_for, so reselect the actor class
	SELECT @ll_ordered_for_actor_id = actor_id,
			@ls_ordered_for_actor_class = actor_class
	FROM c_User
	WHERE user_id = @ls_ordered_for_user_id

	SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

	IF @ll_error <> 0
		RETURN
	END

IF @ls_ordered_for_user_id IS NOT NULL
	INSERT INTO @recipient (
		user_id ,
		actor_class ,
		actor_id ,
		cpr_id)
	VALUES (
		@ls_ordered_for_user_id,
		@ls_ordered_for_actor_class,
		@ll_ordered_for_actor_id,
		@ls_ordered_for_cpr_id
		)

RETURN
END
GO
GRANT SELECT
	ON [dbo].[fn_document_recipient_info]
	TO [cprsystem]
GO

