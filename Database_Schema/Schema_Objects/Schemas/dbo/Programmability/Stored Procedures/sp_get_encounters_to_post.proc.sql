/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 7/25/2000 8:43:45 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 2/16/99 12:00:47 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 10/26/98 2:20:34 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 10/4/98 6:28:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 9/24/98 3:06:01 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_encounters_to_post    Script Date: 8/17/98 4:16:40 PM ******/
CREATE PROCEDURE sp_get_encounters_to_post
AS
SELECT	cpr_id,
	encounter_id
FROM p_Patient_Encounter (NOLOCK)
WHERE billing_posted IN ('N', 'R')
AND bill_flag = 'Y'
AND encounter_status = 'CLOSED'

