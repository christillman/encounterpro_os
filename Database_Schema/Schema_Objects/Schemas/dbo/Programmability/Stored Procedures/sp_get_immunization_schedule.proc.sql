/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 7/25/2000 8:43:47 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 2/16/99 12:00:49 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 10/26/98 2:20:35 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 10/4/98 6:28:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 9/24/98 3:06:02 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_immunization_schedule    Script Date: 8/17/98 4:16:41 PM ******/
CREATE PROCEDURE sp_get_immunization_schedule (
	@pl_disease_id int )
AS
SELECT	schedule_sequence,
	age,
	age_days = datediff(day, '1/1/1980', age),
	warning_days
FROM c_Immunization_Schedule
WHERE disease_id = @pl_disease_id
ORDER BY age

