/****** Object:  Stored Procedure dbo.sp_new_letter    Script Date: 7/25/2000 8:44:01 AM ******/
/****** Object:  Stored Procedure dbo.sp_new_letter    Script Date: 2/16/99 12:01:00 PM ******/
CREATE PROCEDURE sp_new_letter (
	@ps_cpr_id varchar(12),
	@ps_letter_type varchar(24),
	@ps_description varchar(80),
	@pl_attachment_id int,
	@ps_created_by varchar(24),
	@pl_encounter_id int )
AS
INSERT INTO p_Letter (
	cpr_id,
	encounter_id,
	letter_type,
	description,
	attachment_id,
	created,
	created_by)
VALUES (
	@ps_cpr_id,
	@pl_encounter_id,
	@ps_letter_type,
	@ps_description,
	@pl_attachment_id,
	getdate(),
	@ps_created_by)

