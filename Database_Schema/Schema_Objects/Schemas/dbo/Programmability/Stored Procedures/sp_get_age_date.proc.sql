/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 7/25/2000 8:43:33 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 2/16/99 12:00:43 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 10/26/98 2:20:30 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 10/4/98 6:28:04 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 9/24/98 3:05:58 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_age_date    Script Date: 8/17/98 4:16:36 PM ******/
CREATE PROCEDURE sp_get_age_date (
	@pdt_from_date datetime,
	@pl_add_number int,
	@ps_add_unit varchar(12),
	@pdt_date datetime OUTPUT)
AS
IF @ps_add_unit = "DAY"
	SELECT @pdt_date = dateadd(day, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = "WEEK"
	SELECT @pdt_date = dateadd(week, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = "MONTH"
	SELECT @pdt_date = dateadd(month, @pl_add_number, @pdt_from_date)
ELSE IF @ps_add_unit = "YEAR"
	SELECT @pdt_date = dateadd(year, @pl_add_number, @pdt_from_date)

