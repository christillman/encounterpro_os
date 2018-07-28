/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 7/25/2000 8:43:42 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 2/16/99 12:00:45 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 10/26/98 2:20:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 10/4/98 6:28:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 9/24/98 3:06:00 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases    Script Date: 8/17/98 4:16:38 PM ******/
CREATE PROCEDURE sp_get_diseases
AS
SELECT disease_id,
	description,
	display_flag,
	sort_sequence
FROM c_Disease
WHERE status = 'OK'
ORDER BY sort_sequence

