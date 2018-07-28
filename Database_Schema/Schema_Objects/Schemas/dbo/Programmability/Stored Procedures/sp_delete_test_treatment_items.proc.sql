/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 7/25/2000 8:43:39 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 2/16/99 12:00:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 10/26/98 2:20:30 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 10/4/98 6:28:04 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 9/24/98 3:05:57 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 4/6/98 6:26:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 10/2/97 10:49:43 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_test_treatment_items    Script Date: 4/28/97 7:47:56 AM ******/
CREATE PROCEDURE sp_delete_test_treatment_items (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer )
AS
DELETE FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND open_encounter_id = @pl_encounter_id
AND treatment_type = 'TEST'

