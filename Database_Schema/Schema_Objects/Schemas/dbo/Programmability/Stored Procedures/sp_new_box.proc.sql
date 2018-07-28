/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 7/25/2000 8:43:59 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 2/16/99 12:00:58 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 10/26/98 2:20:43 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 10/4/98 6:28:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 9/24/98 3:06:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_box    Script Date: 8/17/98 4:16:49 PM ******/
CREATE PROCEDURE sp_new_box (
	@ps_box_type varchar(24),
	@ps_description varchar(80),
	@pl_box_id int OUTPUT )
AS
INSERT INTO o_Box (box_type, description)
VALUES (@ps_box_type, @ps_description)
SELECT @pl_box_id=@@IDENTITY

