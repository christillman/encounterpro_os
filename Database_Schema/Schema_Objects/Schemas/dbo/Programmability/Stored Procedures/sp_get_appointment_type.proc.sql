/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 7/25/2000 8:43:40 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 2/16/99 12:00:43 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 10/26/98 2:20:31 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 10/4/98 6:28:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 9/24/98 3:05:58 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_appointment_type    Script Date: 8/17/98 4:16:36 PM ******/
CREATE PROCEDURE sp_get_appointment_type (
	@ps_appointment_type varchar(50),
	@ps_encounter_type varchar(24) OUTPUT,
	@ps_new_flag char(1) OUTPUT )
AS
SELECT @ps_encounter_type = encounter_type,
	@ps_new_flag = new_flag
FROM b_Appointment_Type
WHERE appointment_type = @ps_appointment_type
IF @@ROWCOUNT = 0
	SELECT @ps_encounter_type = null,
		@ps_new_flag = null

