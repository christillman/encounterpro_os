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

-- Drop Function [dbo].[fn_user_in_room]
Print 'Drop Function [dbo].[fn_user_in_room]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_user_in_room]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_user_in_room]
GO

-- Create Function [dbo].[fn_user_in_room]
Print 'Create Function [dbo].[fn_user_in_room]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION fn_user_in_room (
	@ps_room_id varchar(12) )

RETURNS varchar(24)

AS

BEGIN

DECLARE @ls_user_in_room varchar(24)

-- First see if someone is logged into the computer associated with the room
SELECT TOP 1 @ls_user_in_room = u.user_id
FROM o_Rooms r
	INNER JOIN o_Users u
	ON r.computer_id = u.computer_id
WHERE r.room_id = @ps_room_id

IF @@ROWCOUNT = 1 AND @ls_user_in_room IS NOT NULL
	RETURN @ls_user_in_room

-- Next see who is actively performing a service for a patient in this room.
-- Favor providers over extenders and staff

DECLARE @usersinroom TABLE (
	user_id varchar(24) NOT NULL,
	sort_sequence int NULL )

INSERT INTO @usersinroom (
	user_id ,
	sort_sequence )
SELECT l.user_id,
		CASE u.license_flag WHEN 'P' THEN 1 WHEN 'E' THEN 2 ELSE 3 END
FROM o_User_Service_Lock l
	INNER JOIN o_Active_Services s
	ON s.patient_workplan_item_id = l.patient_workplan_item_id
	INNER JOIN c_User u
	ON l.user_id = u.user_id
	INNER JOIN p_Patient_Encounter e
	ON e.cpr_id = s.cpr_id
	AND e.encounter_id = s.encounter_id
WHERE e.patient_location = @ps_room_id
AND e.encounter_status = 'OPEN'

SELECT @ls_user_in_room = user_id
FROM @usersinroom
ORDER BY sort_sequence

IF @@ROWCOUNT = 1 AND @ls_user_in_room IS NOT NULL
	RETURN @ls_user_in_room

RETURN NULL

END


GO
GRANT EXECUTE
	ON [dbo].[fn_user_in_room]
	TO [cprsystem]
GO

