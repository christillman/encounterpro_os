/****** Object:  Stored Procedure dbo.sp_get_treatments_to_post    Script Date: 7/25/2000 8:43:56 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_treatments_to_post    Script Date: 2/16/99 12:00:56 PM ******/
CREATE PROCEDURE sp_get_treatments_to_post (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int)
AS
SELECT	encounter_charge_id,
	p_encounter_charge.procedure_type, 	treatment_id,
	procedure_id
FROM	p_Encounter_Charge (NOLOCK)
LEFT OUTER JOIN c_Procedure_Type
ON p_Encounter_Charge.procedure_type = c_Procedure_Type.procedure_type
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id
AND bill_flag = 'Y'
ORDER BY c_Procedure_Type.sort_sequence

