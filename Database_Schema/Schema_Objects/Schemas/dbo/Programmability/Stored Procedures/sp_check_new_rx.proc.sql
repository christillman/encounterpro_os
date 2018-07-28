/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 7/25/2000 8:43:35 AM ******/
/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 2/16/99 12:00:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 10/26/98 2:20:28 PM ******/
/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 10/4/98 6:28:02 PM ******/
/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 9/24/98 3:05:55 PM ******/
/****** Object:  Stored Procedure dbo.sp_check_new_rx    Script Date: 8/17/98 4:16:33 PM ******/
CREATE PROCEDURE sp_check_new_rx (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int,
	@pi_new_rx_count smallint OUTPUT )
AS
SELECT @pi_new_rx_count = count(*)
FROM 	p_Treatment_Item WITH (NOLOCK)
	, c_Drug_Package WITH (NOLOCK)
Where p_Treatment_Item.cpr_id = @ps_cpr_id
AND p_Treatment_Item.open_encounter_id = @pl_encounter_id
AND p_Treatment_Item.treatment_type = 'MEDICATION'
AND p_Treatment_Item.treatment_status IS NULL
AND p_Treatment_Item.drug_id = c_Drug_Package.drug_id
AND p_Treatment_Item.package_id = c_Drug_Package.package_id
AND c_Drug_Package.prescription_flag = 'Y'
AND p_Treatment_Item.signature_attachment_sequence IS NULL

