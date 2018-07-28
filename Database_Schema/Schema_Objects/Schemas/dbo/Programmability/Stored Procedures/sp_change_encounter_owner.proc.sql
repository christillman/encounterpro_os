/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 7/25/2000 8:43:35 AM ******/
/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 2/16/99 12:00:38 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 10/26/98 2:20:27 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 10/4/98 6:28:02 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 9/24/98 3:05:55 PM ******/
/****** Object:  Stored Procedure dbo.sp_change_encounter_owner    Script Date: 8/17/98 4:16:33 PM ******/
CREATE PROCEDURE sp_change_encounter_owner (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer,
	@ps_attending_doctor varchar(24) )
AS
UPDATE p_Patient_Encounter
SET attending_doctor = @ps_attending_doctor
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

