﻿CREATE FUNCTION fn_user_in_room (
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

