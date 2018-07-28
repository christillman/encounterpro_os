/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 7/25/2000 8:43:51 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 2/16/99 12:00:52 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 10/26/98 2:20:37 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 10/4/98 6:28:11 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 9/24/98 3:06:05 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_procedure_count    Script Date: 8/17/98 4:16:44 PM ******/
CREATE PROCEDURE sp_get_procedure_count (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@pi_procedure_count smallint OUTPUT )
AS
SELECT @pi_procedure_count = count(*)
FROM 	p_Encounter_Charge WITH (NOLOCK),
 	p_Treatment_Item WITH (NOLOCK)
WHERE p_Encounter_Charge.cpr_id = @ps_cpr_id
AND p_Encounter_Charge.encounter_id = @pl_encounter_id
AND p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.treatment_id = p_Encounter_Charge.treatment_id

