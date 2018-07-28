/****** Object:  Stored Procedure dbo.sp_set_treatment_attachment_id    Script Date: 7/25/2000 8:44:09 AM ******/
/****** Object:  Stored Procedure dbo.sp_set_treatment_attachment_id    Script Date: 2/16/99 12:01:12 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_treatment_attachment_id    Script Date: 10/26/98 2:20:53 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_treatment_attachment_id    Script Date: 10/4/98 6:28:23 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_treatment_attachment_id    Script Date: 9/24/98 3:06:17 PM ******/
CREATE PROCEDURE sp_set_treatment_attachment_id (
	@ps_cpr_id varchar(12),
	@pl_treatment_id int,
	@pl_attachment_id int )
AS
UPDATE p_Treatment_Item
SET attachment_id = @pl_attachment_id
WHERE cpr_id = @ps_cpr_id AND treatment_id = @pl_treatment_id

