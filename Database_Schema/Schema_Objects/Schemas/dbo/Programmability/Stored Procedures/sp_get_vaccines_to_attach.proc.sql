/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 7/25/2000 8:43:56 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 2/16/99 12:00:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 10/26/98 2:20:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 10/4/98 6:28:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 9/24/98 3:06:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_vaccines_to_attach    Script Date: 8/17/98 4:16:48 PM ******/
CREATE PROCEDURE sp_get_vaccines_to_attach (
	@pl_disease_id int )
AS
SELECT vaccine_id,
	description,
	sort_sequence,
	selected_flag=0
FROM c_Vaccine
WHERE NOT EXISTS (SELECT *
		  FROM c_Vaccine_Disease
		  WHERE c_Vaccine.vaccine_id = c_Vaccine_Disease.vaccine_id
		  AND c_Vaccine_Disease.disease_id = @pl_disease_id)
AND status = 'OK'
ORDER BY sort_sequence

