/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 7/25/2000 8:44:10 AM ******/
/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 2/16/99 12:01:13 PM ******/
/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 10/26/98 2:20:54 PM ******/
/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 10/4/98 6:28:24 PM ******/
/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 9/24/98 3:06:18 PM ******/
/****** Object:  Stored Procedure dbo.sp_unlock_patient    Script Date: 8/17/98 4:16:58 PM ******/
CREATE PROCEDURE sp_unlock_patient (
	@ps_cpr_id varchar(12),
	@ps_user_id varchar(24),
	@ps_locked_by varchar(24) OUTPUT )
AS
UPDATE p_Patient
SET locked_by = null
WHERE cpr_id = @ps_cpr_id
AND locked_by = @ps_user_id
SELECT @ps_locked_by = null
SELECT @ps_locked_by = locked_by
FROM p_Patient
WHERE cpr_id = @ps_cpr_id

