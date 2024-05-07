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

-- Drop Procedure [dbo].[sp_Set_Patient_Authority]
Print 'Drop Procedure [dbo].[sp_Set_Patient_Authority]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_Set_Patient_Authority]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_Set_Patient_Authority]
GO

-- Create Procedure [dbo].[sp_Set_Patient_Authority]
Print 'Create Procedure [dbo].[sp_Set_Patient_Authority]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_Set_Patient_Authority (
	@ps_cpr_id varchar(12),
	@pdt_start_date datetime = NULL,
	@pdt_end_date datetime = NULL,
	@pl_authority_sequence int,
	@ps_authority_id varchar(24),
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS

DECLARE @ls_current_authority_id varchar(24),
		@ls_authority_type varchar(24),
		@ll_error int,
		@ll_count int,
		@ls_status varchar(8)

IF @ps_authority_id IS NULL
	BEGIN
	RAISERROR ('NULL Authority ID',16,-1)
	RETURN
	END

IF @pl_authority_sequence IS NULL
	BEGIN
	RAISERROR ('NULL Authority Sequence',16,-1)
	RETURN
	END

IF @pl_authority_sequence <= 0
	BEGIN
	RAISERROR ('Invalid Authority Sequence (%d)',16,-1, @pl_authority_sequence)
	RETURN
	END

-- Get the authority type
SELECT @ls_authority_type = authority_type
FROM c_Authority
WHERE authority_id = @ps_authority_id

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_count <> 1
	BEGIN
	RAISERROR ('Authority does not exist (%s)',16,-1, @ps_authority_id)
	RETURN
	END

IF @ls_authority_type IS NULL
	BEGIN
	RAISERROR ('NULL Authority Type',16,-1)
	RETURN
	END

-- Find out the current authority for this sequence
SELECT @ls_current_authority_id = authority_id,
		@ls_status = status
FROM p_Patient_Authority
WHERE cpr_id = @ps_cpr_id
AND authority_type = @ls_authority_type
AND authority_sequence = @pl_authority_sequence

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_count = 1
	BEGIN
	-- If the existing authority_id is the same then we're done
	IF @ls_current_authority_id = @ps_authority_id
		BEGIN
		IF ISNULL(@ls_status, 'NA') <> 'OK'
			UPDATE p_Patient_Authority
			SET status = 'OK'
			WHERE cpr_id = @ps_cpr_id
			AND authority_type = @ls_authority_type
			AND authority_sequence = @pl_authority_sequence

		RETURN
		END

	-- Delete the existing authority link
	DELETE
	FROM p_Patient_Authority
	WHERE cpr_id = @ps_cpr_id
	AND authority_type = @ls_authority_type
	AND authority_sequence = @pl_authority_sequence
	END

-- Add the new authority link
INSERT INTO p_Patient_Authority (
	cpr_id,
	authority_type,
	authority_sequence,
	authority_id,
	status,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@ls_authority_type,
	@pl_authority_sequence,
	@ps_authority_id,
	'OK',
	dbo.get_client_datetime(),
	@ps_created_by)

SELECT @ll_error = @@ERROR,
		@ll_count = @@ROWCOUNT

IF @ll_error <> 0
	RETURN
	
GO
GRANT EXECUTE
	ON [dbo].[sp_Set_Patient_Authority]
	TO [cprsystem]
GO

