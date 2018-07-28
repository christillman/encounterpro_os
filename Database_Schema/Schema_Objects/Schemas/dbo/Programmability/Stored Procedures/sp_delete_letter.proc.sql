/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 7/25/2000 8:43:38 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 2/16/99 12:00:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 10/26/98 2:20:30 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 10/4/98 6:28:04 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 9/24/98 3:05:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_letter    Script Date: 8/17/98 4:16:36 PM ******/
CREATE PROCEDURE sp_delete_letter (
	@ps_cpr_id varchar(12),
	@pl_letter_id int )
AS
DELETE FROM p_Letter
WHERE cpr_id = @ps_cpr_id
AND letter_id = @pl_letter_id

