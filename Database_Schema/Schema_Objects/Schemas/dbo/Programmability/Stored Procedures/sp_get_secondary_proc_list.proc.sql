/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 7/25/2000 8:43:54 AM ******/
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 2/16/99 12:00:54 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 10/26/98 2:20:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 10/4/98 6:28:12 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 9/24/98 3:06:06 PM ******/
/****** Object:  Stored Procedure dbo.sp_get_secondary_proc_list    Script Date: 8/17/98 4:16:46 PM ******/
CREATE PROCEDURE sp_get_secondary_proc_list
AS
SELECT	c_Procedure.procedure_id,
	c_Procedure.description,
	sort_sequence = c_Domain.domain_sequence,
	selected_flag=0
FROM	c_Domain,
	c_Procedure
WHERE	c_Domain.domain_id = 'ENC_SEC_PROC'
AND	c_Domain.domain_item = c_Procedure.procedure_id
ORDER BY c_Domain.domain_sequence

