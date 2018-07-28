/****** Object:  Stored Procedure dbo.sp_get_treatment_attachment_id    Script Date: 7/25/2000 8:43:55 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_attachment_id    Script Date: 2/16/99 12:00:56 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_attachment_id    Script Date: 10/26/98 2:20:41 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_attachment_id    Script Date: 10/4/98 6:28:14 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatment_attachment_id    Script Date: 9/24/98 3:06:07 PM ******/
CREATE PROCEDURE sp_get_treatment_attachment_id (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@pl_attachment_id int OUTPUT )
AS
SELECT @pl_attachment_id = attachment_id
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND treatment_id = @pl_treatment_id
IF @pl_attachment_id <= 0 OR @@rowcount = 0 	SELECT @pl_attachment_id = NULL

