/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 7/25/2000 8:43:37 AM ******/
/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 2/16/99 12:00:40 PM ******/
/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 10/26/98 2:20:29 PM ******/
/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 10/4/98 6:28:03 PM ******/
/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 9/24/98 3:05:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_count_who_came_today    Script Date: 8/17/98 4:16:34 PM ******/
CREATE PROCEDURE sp_count_who_came_today (
	@pdt_date datetime,
	@pi_count smallint OUTPUT )
AS
DECLARE @ldt_today datetime,
	@ldt_tomorrow datetime
SELECT @ldt_today = convert(datetime, convert(varchar(10),@pdt_date, 101))
SELECT @ldt_tomorrow = DATEADD(day, 1, @ldt_today)
SELECT @pi_count = count(*)
FROM p_Patient_Encounter (NOLOCK)
WHERE encounter_date >= @ldt_today
AND encounter_date < @ldt_tomorrow
AND encounter_status = 'CLOSED'
AND patient_location <> 'REMOTE'

