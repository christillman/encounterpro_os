/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 7/25/2000 8:43:43 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 2/16/99 12:00:45 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 10/26/98 2:20:32 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 10/4/98 6:28:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 9/24/98 3:06:00 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_diseases_to_attach    Script Date: 8/17/98 4:16:38 PM ******/
CREATE PROCEDURE sp_get_diseases_to_attach (
	@ps_vaccine_id varchar(24) )
AS
SELECT disease_id,
	description,
	display_flag,
	sort_sequence,
	selected_flag=0
FROM c_Disease
WHERE NOT EXISTS (SELECT *
		  FROM c_Vaccine_Disease
		  WHERE c_Disease.disease_id = c_Vaccine_Disease.disease_id
		  AND c_Vaccine_Disease.vaccine_id = @ps_vaccine_id)
AND status = 'OK'
ORDER BY sort_sequence

