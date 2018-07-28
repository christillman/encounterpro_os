/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 7/25/2000 8:43:47 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 2/16/99 12:00:49 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 10/26/98 2:20:35 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 10/4/98 6:28:09 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 9/24/98 3:06:03 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_medication_procs    Script Date: 8/17/98 4:16:42 PM ******/
CREATE PROCEDURE sp_get_medication_procs (
	@ps_drug_id varchar(24),
	@ps_dosage_form varchar(24) )
AS
SELECT DISTINCT c_Procedure.procedure_id,
		c_Procedure.description
FROM	c_Drug_Package,
	c_Package,
	c_Administration_Method_Proc,
	c_Procedure
WHERE	c_Drug_Package.drug_id = @ps_drug_id
AND	c_Drug_Package.package_id = c_Package.package_id
AND	c_Package.dosage_form = @ps_dosage_form
AND	c_Package.administer_method = c_Administration_Method_Proc.administer_method
AND	c_Administration_Method_Proc.procedure_id = c_Procedure.procedure_id

