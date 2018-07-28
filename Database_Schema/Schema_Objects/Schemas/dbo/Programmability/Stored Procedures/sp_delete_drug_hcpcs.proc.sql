/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 7/25/2000 8:43:38 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 2/16/99 12:00:41 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 10/26/98 2:20:29 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 10/4/98 6:28:03 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 9/24/98 3:05:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_drug_hcpcs    Script Date: 8/17/98 4:16:35 PM ******/
CREATE PROCEDURE sp_delete_drug_hcpcs (
	@ps_drug_id varchar(24),
	@pl_hcpcs_sequence int )
AS
DELETE FROM c_Drug_HCPCS
WHERE drug_id = @ps_drug_id
AND hcpcs_sequence = @pl_hcpcs_sequence

