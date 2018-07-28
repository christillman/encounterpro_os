/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 7/25/2000 8:43:40 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 2/16/99 12:00:43 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 10/26/98 2:20:31 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 10/4/98 6:28:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 9/24/98 3:05:58 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type_list    Script Date: 8/17/98 4:16:37 PM ******/
CREATE PROCEDURE sp_get_appointment_type_list
AS
SELECT	appointment_type,
	encounter_type,
	new_flag
FROM b_Appointment_Type

