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

-- Drop Trigger [dbo].[tr_p_Encounter_Charge_insert]
Print 'Drop Trigger [dbo].[tr_p_Encounter_Charge_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_Encounter_Charge_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_Encounter_Charge_insert]
GO

-- Create Trigger [dbo].[tr_p_Encounter_Charge_insert]
Print 'Create Trigger [dbo].[tr_p_Encounter_Charge_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_Encounter_Charge_insert ON dbo.p_Encounter_Charge
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_encounter_id int,
		@ll_encounter_charge_id int,
		@ll_sort_sequence int

DECLARE lc_sort CURSOR LOCAL FAST_FORWARD FOR
	SELECT cpr_id, encounter_id, encounter_charge_id
	FROM inserted
	WHERE sort_sequence IS NULL

OPEN lc_sort

FETCH lc_sort INTO @ls_cpr_id, @ll_encounter_id, @ll_encounter_charge_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ll_sort_sequence = MAX(sort_sequence)
	FROM dbo.p_Encounter_Charge
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id

	IF @ll_sort_sequence IS NULL
		SET @ll_sort_sequence = 1

	UPDATE dbo.p_Encounter_Charge
	SET sort_sequence = @ll_sort_sequence
	WHERE cpr_id = @ls_cpr_id
	AND encounter_id = @ll_encounter_id
	AND encounter_charge_id = @ll_encounter_charge_id

	FETCH lc_sort INTO @ls_cpr_id, @ll_encounter_id, @ll_encounter_charge_id
	END

CLOSE lc_sort
DEALLOCATE lc_sort

GO

