/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 7/25/2000 8:44:00 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 2/16/99 12:00:59 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 10/26/98 2:20:44 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 10/4/98 6:28:16 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 9/24/98 3:06:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_new_drug_hcpcs    Script Date: 8/17/98 4:16:50 PM ******/
CREATE PROCEDURE sp_new_drug_hcpcs (
	@ps_drug_id varchar(24),
	@pr_administer_amount real,
	@ps_administer_unit varchar(12),
	@ps_hcpcs_procedure_id varchar(24) )
AS
DECLARE @ll_hcpcs_sequence integer
SELECT @ll_hcpcs_sequence = max(hcpcs_sequence)
FROM c_Drug_HCPCS
WHERE drug_id = @ps_drug_id
IF @ll_hcpcs_sequence is null
	SELECT @ll_hcpcs_sequence = 1
ELSE
	SELECT @ll_hcpcs_sequence = @ll_hcpcs_sequence + 1
INSERT INTO c_Drug_HCPCS (
	drug_id,
	hcpcs_sequence,
	administer_amount,
	administer_unit,
	hcpcs_procedure_id )
VALUES (
	@ps_drug_id,
	@ll_hcpcs_sequence,
	@pr_administer_amount,
	@ps_administer_unit,
	@ps_hcpcs_procedure_id )

