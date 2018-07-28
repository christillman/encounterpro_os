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

-- Drop Function [dbo].[fn_special_user_resolution]
Print 'Drop Function [dbo].[fn_special_user_resolution]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_special_user_resolution]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_special_user_resolution]
GO

-- Create Function [dbo].[fn_special_user_resolution]
Print 'Create Function [dbo].[fn_special_user_resolution]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_special_user_resolution (
	@ps_ordered_for varchar(24),
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)

RETURNS varchar(24)

AS
BEGIN
DECLARE @ls_user_id varchar(24),
		@ls_attending_doctor varchar(24),
		@ll_relation_sequence int

SET @ls_user_id = NULL

-- If it's not a special user, then just return the user
IF NOT EXISTS (SELECT 1 FROM c_User WHERE user_id = @ps_ordered_for AND actor_class = 'special')
	RETURN @ps_ordered_for

IF @ps_ordered_for = '#PATIENT_PROVIDER'
	BEGIN
	SELECT @ls_user_id = primary_provider_id
	FROM p_Patient
	WHERE cpr_id = @ps_cpr_id
	END
	
	
IF @ps_ordered_for = '#ENCOUNTER_OWNER'
	BEGIN
	SELECT @ls_user_id = attending_doctor
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	END


IF @ps_ordered_for = '#ENCOUNTER_SUPERVISOR'
	BEGIN
	SELECT @ls_user_id = supervising_doctor,
		@ls_attending_doctor = attending_doctor
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	
	IF @ls_user_id IS NULL
		BEGIN
		SELECT @ls_user_id = supervisor_user_id
		FROM c_User
		WHERE [user_id] = @ls_attending_doctor
		
		IF @ls_user_id IS NULL
			SET @ls_user_id = @ls_attending_doctor
		END
	END

IF @ps_ordered_for = '#PATIENT'
	BEGIN
	SET @ls_user_id = '##' + @ps_cpr_id
	END

IF @ps_ordered_for = '#PARENT'
	BEGIN
	SELECT @ll_relation_sequence = max(relation_sequence)
	FROM p_Patient_Relation
	WHERE cpr_id = @ps_cpr_id
	AND guardian_flag = 'Y'
	AND status = 'OK'
	
	IF @ll_relation_sequence IS NULL
		SET @ls_user_id = '##' + @ps_cpr_id
	ELSE
		SELECT @ls_user_id = '##' + relation_cpr_id
		FROM p_Patient_Relation
		WHERE cpr_id = @ps_cpr_id
		AND relation_sequence = @ll_relation_sequence
	END

IF @ps_ordered_for = '#REFERFROM'
	BEGIN
	SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'referring_provider_id')
	IF @ls_user_id IS NULL
		SELECT @ls_user_id = referring_provider_id
		FROM p_Patient
		WHERE cpr_id = @ps_cpr_id
	END

IF @ps_ordered_for = '#REFERTO'
	BEGIN
	SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Encounter', @pl_encounter_id, 'referred_to_provider_id')
	IF @ls_user_id IS NULL
		SET @ls_user_id = dbo.fn_patient_object_property(@ps_cpr_id, 'Patient', NULL, 'referred_to_provider_id')
	END


RETURN @ls_user_id 

END

GO
GRANT EXECUTE
	ON [dbo].[fn_special_user_resolution]
	TO [cprsystem]
GO

