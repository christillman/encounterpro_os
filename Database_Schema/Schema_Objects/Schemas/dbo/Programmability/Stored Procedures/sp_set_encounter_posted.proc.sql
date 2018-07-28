/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 7/25/2000 8:44:06 AM ******/
/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 2/16/99 12:01:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 10/26/98 2:20:50 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 10/4/98 6:28:21 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 9/24/98 3:06:15 PM ******/
/****** Object:  Stored Procedure dbo.sp_set_encounter_posted    Script Date: 8/17/98 4:16:55 PM ******/
CREATE PROCEDURE sp_set_encounter_posted (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer )
AS
UPDATE p_Patient_Encounter
SET billing_posted = 'Y'
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

