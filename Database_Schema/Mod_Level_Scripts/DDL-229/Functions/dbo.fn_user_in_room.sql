
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

DECLARE @ls_user_in_room varchar(24) = NULL

-- First see if someone is logged into the computer associated with the room
SELECT TOP 1 @ls_user_in_room = u.user_id
FROM o_Rooms r
	INNER JOIN o_Users u
	ON r.computer_id = u.computer_id
WHERE r.room_id = @ps_room_id

IF @ls_user_in_room IS NOT NULL
	RETURN @ls_user_in_room

-- Next see who is actively performing a service for a patient in this room.
-- Favor providers over extenders and staff

;WITH usersinroom AS (
	SELECT l.user_id,
			CASE u.license_flag WHEN 'P' THEN 1 WHEN 'E' THEN 2 ELSE 3 END AS sort_sequence
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
)
SELECT TOP 1 @ls_user_in_room = user_id
FROM usersinroom
ORDER BY sort_sequence

IF @ls_user_in_room IS NOT NULL
	RETURN @ls_user_in_room

RETURN NULL

END


GO
GRANT EXECUTE ON [dbo].[fn_user_in_room] TO [cprsystem]
GO

