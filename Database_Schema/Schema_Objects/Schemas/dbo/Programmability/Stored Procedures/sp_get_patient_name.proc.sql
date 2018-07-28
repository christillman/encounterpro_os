/****** Object:  Stored Procedure dbo.sp_get_patient_name    Script Date: 7/25/2000 8:43:50 AM ******/
CREATE PROCEDURE sp_get_patient_name (
	@ps_cpr_id varchar(12),
	@ps_patient_name varchar(50) OUTPUT )
AS
SELECT @ps_patient_name = COALESCE(first_name + ' ', '') + COALESCE(middle_name + ' ', '') + COALESCE(last_name, '')
FROM p_Patient WITH (NOLOCK)
WHERE cpr_id = @ps_cpr_id

