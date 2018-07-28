/****** Object:  Stored Procedure dbo.sp_get_hcpcs    Script Date: 7/25/2000 8:43:46 AM ******/
CREATE PROCEDURE sp_get_hcpcs (
	@ps_drug_id varchar(24) )
AS
SELECT	c_Drug_HCPCS.hcpcs_sequence,
	c_Drug_HCPCS.administer_amount,
	c_Drug_HCPCS.administer_unit,
	c_Drug_HCPCS.hcpcs_procedure_id,
	c_Procedure.description,
	c_Procedure.cpt_code, 	selected_flag = 0
FROM c_Drug_HCPCS,
c_Procedure
WHERE c_Drug_HCPCS.hcpcs_procedure_id = c_Procedure.procedure_id
AND c_Drug_HCPCS.drug_id = @ps_drug_id
AND c_Procedure.status = 'OK'

