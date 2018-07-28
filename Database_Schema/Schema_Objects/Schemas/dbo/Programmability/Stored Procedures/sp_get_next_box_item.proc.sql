/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 7/25/2000 8:43:47 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 2/16/99 12:00:49 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 10/26/98 2:20:35 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 10/4/98 6:28:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 9/24/98 3:06:03 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_next_box_item    Script Date: 8/17/98 4:16:42 PM ******/
CREATE PROCEDURE sp_get_next_box_item (
	@pl_box_id integer,
	@pl_next_box_item integer OUTPUT )
AS
UPDATE o_Box
SET last_item = last_item + 1
WHERE box_id = @pl_box_id
IF @@ROWCOUNT = 0
	SELECT @pl_next_box_item = 0
ELSE
	SELECT @pl_next_box_item = last_item
	FROM o_Box
	WHERE box_id = @pl_box_id

