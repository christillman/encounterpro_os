/****** Object:  Stored Procedure dbo.sp_get_all_encounter_procs    Script Date: 7/25/2000 8:43:40 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_all_encounter_procs    Script Date: 2/16/99 12:00:43 PM ******/
CREATE PROCEDURE sp_get_all_encounter_procs
AS
SELECT DISTINCT
	procedure_id,
	description,
	cpt_code,
	selected_flag = 0
FROM	c_Procedure
WHERE procedure_category_id = 'VISIT'
AND status = 'OK'

