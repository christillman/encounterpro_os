/****** Object:  Stored Procedure dbo.sp_delete_encounter    Script Date: 7/25/2000 8:44:14 AM ******/
/****** Object:  Stored Procedure dbo.sp_delete_encounter    Script Date: 2/16/99 12:00:42 PM ******/
/****** Object:  Stored Procedure dbo.sp_delete_encounter    Script Date: 10/26/98 2:20:29 PM ******/
CREATE PROCEDURE sp_delete_encounter (
	@ps_cpr_id varchar(12),
	@pl_encounter_id integer )
AS
DECLARE @li_count smallint
SELECT @li_count = count(*)
FROM p_Assessment
WHERE cpr_id = @ps_cpr_id
AND open_encounter_id = @pl_encounter_id
IF @li_count > 0
	BEGIN
	RAISERROR ('Encounter has assessments',16,-1)
	ROLLBACK TRANSACTION
	return
	END
SELECT @li_count = count(*)
FROM p_Treatment_Item
WHERE cpr_id = @ps_cpr_id
AND open_encounter_id = @pl_encounter_id
IF @li_count > 0
	BEGIN
	RAISERROR ('Encounter has treatments',16,-1)
	ROLLBACK TRANSACTION
	return
	END
DELETE FROM p_Patient_Encounter
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

