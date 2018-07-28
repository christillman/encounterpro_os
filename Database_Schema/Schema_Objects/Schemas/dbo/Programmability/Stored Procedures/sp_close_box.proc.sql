/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 7/25/2000 8:43:36 AM ******/
/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 2/16/99 12:00:40 PM ******/
/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 10/26/98 2:20:28 PM ******/
/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 10/4/98 6:28:02 PM ******/
/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 9/24/98 3:05:55 PM ******/
/****** Object:  Stored Procedure dbo.sp_close_box    Script Date: 8/17/98 4:16:34 PM ******/
CREATE PROCEDURE sp_close_box (
	@pl_box_id int )
AS
UPDATE o_box
SET box_close_date = getdate()
WHERE box_id = @pl_box_id

