--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_p_treatment_progress_insert]
Print 'Drop Trigger [dbo].[tr_p_treatment_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_treatment_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_treatment_progress_insert]
GO

-- Create Trigger [dbo].[tr_p_treatment_progress_insert]
Print 'Create Trigger [dbo].[tr_p_treatment_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_treatment_progress_insert ON dbo.p_Treatment_Progress
FOR INSERT
AS
IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12),
		@ll_problem_id int, 
		@ll_encounter_id int, 
		@ls_created_by varchar(24), 
		@ls_progress_type varchar(24)

DECLARE
	 @Add_Instruction_flag SMALLINT
	,@Assessment_flag SMALLINT
	,@ATTACHMENT_FOLDER_flag SMALLINT
	,@ATTACHMENT_TAG_flag SMALLINT
	,@CANCELLED_flag SMALLINT
	,@CHANGED_flag SMALLINT
	,@Closed_flag SMALLINT
	,@COLLECTED_flag SMALLINT
	,@COMPLETED_flag SMALLINT
	,@CONSOLIDATED_flag SMALLINT
	,@DECEASED_flag SMALLINT
	,@DELETED_flag SMALLINT
	,@DISPATCHED_flag SMALLINT
	,@DOLATER_flag SMALLINT
	,@ESCALATE_flag SMALLINT
	,@Effectiveness_flag SMALLINT
	,@Effectiveness_Comment_flag SMALLINT
	,@EXPIRE_flag SMALLINT
	,@MODIFIED_flag SMALLINT
	,@Modify_flag SMALLINT
	,@MOVED_flag SMALLINT
	,@NEEDSAMPLE_flag SMALLINT
	,@Property_flag SMALLINT
	,@REDIAGNOSED_flag SMALLINT
	,@ReOpen_flag SMALLINT
	,@Revert_flag SMALLINT
	,@Runtime_Configured_flag SMALLINT
	,@skipped_flag SMALLINT
	,@STARTED_flag SMALLINT
	,@TEXT_flag SMALLINT
	,@UNCancelled_flag SMALLINT
	,@Confidential_flag smallint


/*
	This query sets a numberic flag to a value greater than 0 whenever one or more records in the 
	inserted table has the progress_type be checked for.  The flags are then used to only execute
	applicable queries.
*/

SELECT
	 @Add_Instruction_flag = SUM( CHARINDEX( 'Add Instruction', inserted.progress_type ) )
	,@Assessment_flag = SUM( CHARINDEX( 'ASSESSMENT', inserted.progress_type ) )
	,@ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@CANCELLED_flag = SUM( CHARINDEX( 'CANCELLED', inserted.progress_type ) )
	,@CHANGED_flag = SUM( CHARINDEX( 'CHANGED', inserted.progress_type ) )
	,@Closed_flag = SUM( CHARINDEX( 'Closed', inserted.progress_type ) )
	,@COLLECTED_flag = SUM( CHARINDEX( 'COLLECTED', inserted.progress_type ) )
	,@COMPLETED_flag = SUM( CHARINDEX( 'COMPLETED', inserted.progress_type ) )
	,@CONSOLIDATED_flag = SUM( CHARINDEX( 'CONSOLIDATED', inserted.progress_type ) )
	,@DECEASED_flag = SUM( CHARINDEX( 'DECEASED', inserted.progress_type ) )
	,@DELETED_flag = SUM( CHARINDEX( 'DELETED', inserted.progress_type ) )
	,@DISPATCHED_flag = SUM( CHARINDEX( 'DISPATCHED', inserted.progress_type ) )
	,@DOLATER_flag = SUM( CHARINDEX( 'DOLATER', inserted.progress_type ) )
	,@ESCALATE_flag = SUM( CHARINDEX( 'ESCALATE', inserted.progress_type ) )
	,@Effectiveness_flag = SUM( CHARINDEX( 'Effectiveness', inserted.progress_type ) )
	,@Effectiveness_Comment_flag = SUM( CHARINDEX( 'Effectiveness Comment', inserted.progress_type ) )
	,@EXPIRE_flag = SUM( CHARINDEX( 'EXPIRE', inserted.progress_type ) )
	,@MODIFIED_flag = SUM( CHARINDEX( 'MODIFIED', inserted.progress_type ) )
	,@Modify_flag = SUM( CHARINDEX( 'Modify', inserted.progress_type ) )
	,@MOVED_flag = SUM( CHARINDEX( 'MOVED', inserted.progress_type ) )
	,@NEEDSAMPLE_flag = SUM( CHARINDEX( 'NEEDSAMPLE', inserted.progress_type ) )
	,@Property_flag = SUM( CHARINDEX( 'Property', inserted.progress_type ) )
	,@REDIAGNOSED_flag = SUM( CHARINDEX( 'REDIAGNOSED', inserted.progress_type ) )
	,@ReOpen_flag = SUM( CHARINDEX( 'ReOpen', inserted.progress_type ) )
	,@Revert_flag = SUM( CHARINDEX( 'Revert To Original Owner', inserted.progress_type ) )
	,@Runtime_Configured_flag = SUM( CHARINDEX( 'Runtime_Configured', inserted.progress_type ) )
	,@skipped_flag = SUM( CHARINDEX( 'Skipped', inserted.progress_type ) )
	,@STARTED_flag = SUM( CHARINDEX( 'STARTED', inserted.progress_type ) )
	,@TEXT_flag = SUM( CHARINDEX( 'TEXT', inserted.progress_type ) )
	,@UNCancelled_flag = SUM( CHARINDEX( 'UNCancelled', inserted.progress_type ) )
	,@Confidential_flag = SUM( CHARINDEX( 'CONFIDENTIAL', inserted.progress_type ) )
FROM inserted

IF @Confidential_flag > 0
	BEGIN
	UPDATE t
	SET	default_grant = CASE i.progress_key WHEN 'Allow' THEN 1 
												WHEN 'Deny' THEN 0 
												ELSE t.default_grant END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
	WHERE i.progress_type = 'CONFIDENTIAL'
	END

-- Reopen parent treatment record

IF @Reopen_flag > 0
BEGIN
	UPDATE p_Treatment_Item
	SET	treatment_status = NULL,
		end_date = NULL,
		close_encounter_id = NULL,
		completed_by = NULL,
		open_flag = 'Y'
	FROM inserted
	WHERE inserted.cpr_id = p_Treatment_Item.cpr_id
	AND inserted.treatment_id = p_Treatment_Item.treatment_id
	AND inserted.progress_type = 'ReOpen'
	AND p_Treatment_Item.treatment_status IN ('CLOSED', 'CANCELLED', 'MODIFIED')
END


-- Update the parent treatment record

IF
(		@CLOSED_flag > 0
	OR	@CANCELLED_flag > 0
	OR	@MODIFIED_flag > 0
	OR	@COLLECTED_flag > 0
	OR	@NEEDSAMPLE_flag > 0
)
BEGIN
	UPDATE p_Treatment_Item
	SET	treatment_status = inserted.progress_type,
		end_date = inserted.progress_date_time,
		close_encounter_id = inserted.encounter_id,
		completed_by = inserted.user_id,
		open_flag = CASE WHEN inserted.progress_type IN ('CLOSED', 'CANCELLED', 'MODIFIED') THEN 'N' ELSE 'Y' END
	FROM inserted
	WHERE inserted.cpr_id = p_Treatment_Item.cpr_id
	AND inserted.treatment_id = p_Treatment_Item.treatment_id
	AND inserted.progress_type IN ('CLOSED', 'CANCELLED', 'MODIFIED', 'COLLECTED', 'NEEDSAMPLE')
	AND ISNULL(p_Treatment_Item.treatment_status, 'OPEN') <> 'CANCELLED'
END


-- Allow cancellation of 'CLOSED'treatments

IF @CANCELLED_flag > 0
BEGIN
	-- Billing Algorithm 8-a
	-- Cancel associated charges
	UPDATE p_Encounter_Charge
	SET bill_flag = 'N'
	FROM inserted
	WHERE inserted.cpr_id = p_Encounter_Charge.cpr_id
	AND inserted.encounter_id = p_Encounter_Charge.encounter_id
	AND inserted.treatment_id = p_Encounter_Charge.treatment_id
	AND inserted.progress_type = 'CANCELLED'
	
	UPDATE p_Observation_Comment
	SET current_flag = 'N'
	FROM inserted
	WHERE inserted.cpr_id = p_Observation_Comment.cpr_id
	AND inserted.treatment_id = p_Observation_Comment.treatment_id
	AND inserted.progress_type = 'CANCELLED'
	
	UPDATE p_Observation_Result
	SET current_flag = 'N'
	FROM inserted
	WHERE inserted.cpr_id = p_Observation_Result.cpr_id
	AND inserted.treatment_id = p_Observation_Result.treatment_id
	AND inserted.progress_type = 'CANCELLED'

	-- Billing Algorithm 8-b
	-- Set bill_flag = N for any assessment-billing records that are associated with charges and not associated with any diagnosis
	UPDATE pea
	SET bill_flag = 'N'
	FROM p_Encounter_Assessment pea
		INNER JOIN p_Encounter_Assessment_Charge ac
		ON pea.cpr_id = ac.cpr_id
		AND pea.encounter_id = ac.encounter_id
		AND pea.problem_id = ac.problem_id
		INNER JOIN p_Encounter_Charge c
		ON ac.cpr_id = c.cpr_id
		AND ac.encounter_id = c.encounter_id
		AND ac.encounter_charge_id = c.encounter_charge_id
		INNER JOIN inserted i
		ON i.cpr_id = c.cpr_id
		AND i.encounter_id = c.encounter_id
		AND i.treatment_id = c.treatment_id
	WHERE i.progress_type = 'CANCELLED'
	AND NOT EXISTS (
		SELECT 1
		FROM p_Assessment a
		WHERE pea.cpr_id = a.cpr_id
		AND pea.problem_id = a.problem_id)

	-- Ghost followup problem - Cancel the workplan item that spawned this treatment
	UPDATE wi
	SET status = 'Cancelled'
	FROM p_Patient_WP_Item wi
		INNER JOIN inserted i
		ON i.cpr_id = wi.cpr_id
		AND i.treatment_id = wi.treatment_id
		INNER JOIN p_Patient_WP w
		ON w.patient_workplan_id = wi.patient_workplan_id
	WHERE i.progress_type = 'CANCELLED'
	AND w.workplan_type IN ('Followup', 'Referral')
	AND ISNULL(wi.status, 'Open') <> 'Cancelled'
END

IF @UNCancelled_flag > 0
BEGIN
	-- First uncancel the treatment record
	UPDATE t
	SET	treatment_status = p.progress_type,
		end_date = p.progress_date_time,
		close_encounter_id = p.encounter_id,
		completed_by = p.user_id,
		open_flag = CASE WHEN p.progress_type IN ('CLOSED', 'CANCELLED', 'MODIFIED') THEN 'N' ELSE 'Y' END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
		LEFT OUTER JOIN p_Treatment_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.treatment_id = p.treatment_id
		AND p.progress_type = 'CLOSED'
	WHERE i.progress_type = 'UNCancelled'

	-- Then uncancel the observation results
	UPDATE r
	SET current_flag = 'Y'
	FROM p_Observation_Result r
		INNER JOIN inserted i
		ON i.cpr_id = r.cpr_id
		AND i.treatment_id = r.treatment_id
	AND i.progress_type = 'UNCancelled'

	UPDATE r
	SET current_flag = 'N'
	FROM p_Observation_Result r
		INNER JOIN inserted i
		ON i.cpr_id = r.cpr_id
		AND i.treatment_id = r.treatment_id
		INNER JOIN p_Observation_Result rx
		ON r.cpr_id = rx.cpr_id
		AND r.observation_sequence = rx.observation_sequence
		AND r.location = rx.location
		AND r.result_sequence = rx.result_sequence
	WHERE i.progress_type = 'UNCancelled'
	AND (r.location_result_sequence < rx.location_result_sequence
		OR r.result_date_time IS NULL)
	
	-- Then uncancel the observation results
	UPDATE c
	SET current_flag = 'N'
	FROM p_Observation_Comment c
		INNER JOIN inserted i
		ON i.cpr_id = c.cpr_id
		AND i.treatment_id = c.treatment_id
	WHERE i.progress_type = 'UNCancelled'

	UPDATE c
	SET current_flag = 'N'
	FROM p_Observation_Comment c
		INNER JOIN inserted i
		ON i.cpr_id = c.cpr_id
		AND i.treatment_id = c.treatment_id
		INNER JOIN p_Observation_Comment cx
		ON c.cpr_id = cx.cpr_id
		AND c.observation_sequence = cx.observation_sequence
		AND c.comment_type = cx.comment_type
		AND ISNULL(c.comment_title, '!NULL') = ISNULL(cx.comment_title, '!NULL')
		AND c.comment_date_time = cx.comment_date_time
	WHERE i.progress_type = 'UNCancelled'
	AND (c.Observation_comment_id < cx.Observation_comment_id
		OR (c.short_comment IS NULL AND c.comment IS NULL AND c.attachment_id IS NULL) )
	
	
END

-- Update the risk_level

IF UPDATE( risk_level )
BEGIN
	UPDATE p_Treatment_Item
	SET	risk_level = inserted.risk_level
	FROM inserted
	WHERE inserted.cpr_id = p_Treatment_Item.cpr_id
	AND inserted.treatment_id = p_Treatment_Item.treatment_id
	AND inserted.risk_level IS NOT NULL
	AND ISNULL( p_Treatment_Item.risk_level, 0 ) < inserted.risk_level
END

IF @Modify_flag > 0
BEGIN
/*
	INSERT INTO p_Treatment_Progress (
			cpr_id,
			treatment_id,
			encounter_id,
			[user_id],
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			attachment_id,
			patient_workplan_item_id,
			risk_level,
			current_flag,
			created,
			created_by,
			id)
	SELECT	i.cpr_id,
			i.treatment_id,
			i.encounter_id,
			i.[user_id],
			i.progress_date_time,
			'Original Value',
			i.progress_key,
			progress_value = CASE i.progress_key WHEN 'begin_date' THEN CONVERT(varchar(40), t.begin_date) 
												WHEN 'package_id' THEN t.package_id 
												WHEN 'specialty_id' THEN t.specialty_id 
												WHEN 'procedure_id' THEN t.procedure_id 
												WHEN 'drug_id' THEN t.drug_id 
												WHEN 'observation_id' THEN t.observation_id 
												WHEN 'administration_sequence' THEN t.administration_sequence 
												WHEN 'dose_amount' then CONVERT(varchar(40), t.dose_amount) 
												WHEN 'dose_unit' THEN t.dose_unit 
												WHEN 'administer_frequency' THEN t.administer_frequency 
												WHEN 'duration_amount' then CONVERT(varchar(40), t.duration_amount) 
												WHEN 'duration_unit' THEN t.duration_unit 
												WHEN 'duration_prn' THEN t.duration_prn 
												WHEN 'dispense_amount' then CONVERT(varchar(40), t.dispense_amount) 
												WHEN 'office_dispense_amount' then CONVERT(varchar(40), t.office_dispense_amount) 
												WHEN 'dispense_unit' THEN t.dispense_unit 
												WHEN 'brand_name_required' THEN t.brand_name_required 
												WHEN 'refills' then CONVERT(varchar(40), t.refills) 
												WHEN 'location' THEN t.location 
												WHEN 'maker_id' THEN t.maker_id 
												WHEN 'lot_number' THEN t.lot_number 
												WHEN 'expiration_date' then CONVERT(varchar(40), t.expiration_date) 
												WHEN 'send_out_flag' THEN t.send_out_flag 
												WHEN 'original_treatment_id' then CONVERT(varchar(40), t.original_treatment_id) 
												WHEN 'referral_question' THEN t.referral_question 
												WHEN 'referral_question_assmnt_id' THEN t.referral_question_assmnt_id 
												WHEN 'material_id' then CONVERT(varchar(40), t.material_id) 
												WHEN 'treatment_mode' THEN t.treatment_mode 
												WHEN 'office_id' THEN t.office_id 
												WHEN 'treatment_status' THEN t.treatment_status 
												WHEN 'treatment_description' THEN CONVERT(varchar(40), t.treatment_description)
												WHEN 'treatment_goal' THEN CONVERT(varchar(40), t.treatment_goal)
												WHEN 'end_date' then CONVERT(varchar(40), t.end_date) END,
			i.attachment_id,
			i.patient_workplan_item_id,
			i.risk_level,
			'N',
			getdate(),
			i.created_by,
			newid()
	FROM inserted i
		INNER JOIN p_Treatment_Item t
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id
	WHERE progress_type = 'Modify'
	AND NOT EXISTS (SELECT treatment_progress_sequence
					FROM p_Treatment_Progress p
					WHERE p.cpr_id = i.cpr_id
					AND p.treatment_id = i.treatment_id
					AND p.progress_type = i.progress_type
					AND p.progress_key = i.progress_key
					AND p.treatment_progress_sequence <> i.treatment_progress_sequence)
*/
	UPDATE t
	SET begin_date = CASE i.progress_key WHEN 'begin_date' then CONVERT(datetime, i.progress_value) ELSE t.begin_date END,
		package_id = CASE i.progress_key WHEN 'package_id' then i.progress_value ELSE t.package_id END,
		specialty_id = CASE i.progress_key WHEN 'specialty_id' then i.progress_value ELSE t.specialty_id END,
		procedure_id = CASE i.progress_key WHEN 'procedure_id' then i.progress_value ELSE t.procedure_id END,
		drug_id = CASE i.progress_key WHEN 'drug_id' then i.progress_value ELSE t.drug_id END,
		observation_id = CASE i.progress_key WHEN 'observation_id' then i.progress_value ELSE t.observation_id END,
		administration_sequence = CASE i.progress_key WHEN 'administration_sequence' then i.progress_value ELSE t.administration_sequence END,
		dose_amount = CASE i.progress_key WHEN 'dose_amount' then CONVERT(real, i.progress_value) ELSE t.dose_amount END,
		dose_unit = CASE i.progress_key WHEN 'dose_unit' then i.progress_value ELSE t.dose_unit END,
		administer_frequency = CASE i.progress_key WHEN 'administer_frequency' then i.progress_value ELSE t.administer_frequency END,
		duration_amount = CASE i.progress_key WHEN 'duration_amount' then CONVERT(real, i.progress_value) ELSE t.duration_amount END,
		duration_unit = CASE i.progress_key WHEN 'duration_unit' then i.progress_value ELSE t.duration_unit END,
		duration_prn = CASE i.progress_key WHEN 'duration_prn' then i.progress_value ELSE t.duration_prn END,
		dispense_amount = CASE i.progress_key WHEN 'dispense_amount' then CONVERT(real, i.progress_value) ELSE t.dispense_amount END,
		office_dispense_amount = CASE i.progress_key WHEN 'office_dispense_amount' then CONVERT(real, i.progress_value) ELSE t.office_dispense_amount END,
		dispense_unit = CASE i.progress_key WHEN 'dispense_unit' then i.progress_value ELSE t.dispense_unit END,
		brand_name_required = CASE i.progress_key WHEN 'brand_name_required' then i.progress_value ELSE t.brand_name_required END,
		refills = CASE i.progress_key WHEN 'refills' then CONVERT(smallint, i.progress_value) ELSE t.refills END,
		location = CASE i.progress_key WHEN 'location' then i.progress_value ELSE t.location END,
		maker_id = CASE i.progress_key WHEN 'maker_id' then i.progress_value ELSE t.maker_id END,
		lot_number = CASE i.progress_key WHEN 'lot_number' then i.progress_value ELSE t.lot_number END,
		expiration_date = CASE i.progress_key WHEN 'expiration_date' then CONVERT(datetime, i.progress_value) ELSE t.expiration_date END,
		send_out_flag = CASE i.progress_key WHEN 'send_out_flag' then i.progress_value ELSE t.send_out_flag END,
		original_treatment_id = CASE i.progress_key WHEN 'original_treatment_id' then CONVERT(int, i.progress_value) ELSE t.original_treatment_id END,
		referral_question = CASE i.progress_key WHEN 'referral_question' then i.progress_value ELSE t.referral_question END,
		referral_question_assmnt_id = CASE i.progress_key WHEN 'referral_question_assmnt_id' then i.progress_value ELSE t.referral_question_assmnt_id END,
		material_id = CASE i.progress_key WHEN 'material_id' then CONVERT(int, i.progress_value) ELSE t.material_id END,
		treatment_mode = CASE i.progress_key WHEN 'treatment_mode' then i.progress_value ELSE t.treatment_mode END,
		office_id = CASE i.progress_key WHEN 'office_id' then i.progress_value ELSE t.office_id END,
		treatment_status = CASE i.progress_key WHEN 'treatment_status' then i.progress_value ELSE t.treatment_status END,
		end_date = CASE i.progress_key WHEN 'end_date' then CONVERT(datetime, i.progress_value) ELSE t.end_date END,
		ordered_for = CASE i.progress_key WHEN 'ordered_for' then i.progress_value ELSE t.ordered_for END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
	WHERE i.progress_type = 'Modify'
	AND i.progress_key NOT IN ('treatment_description', 'treatment_goal')

	-- Do the treatment_description seperately because it might be in the [progress] field
	UPDATE t
	SET treatment_description = CASE i.progress_key WHEN 'treatment_description' then CAST(COALESCE(p.progress_value, p.progress) as varchar(80)) ELSE t.treatment_description END,
		treatment_goal = CASE i.progress_key WHEN 'treatment_goal' then CAST(COALESCE(p.progress_value, p.progress) as varchar(80)) ELSE t.treatment_goal END
	FROM p_Treatment_Item t
		INNER JOIN inserted i
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
		INNER JOIN p_Treatment_Progress p
		ON i.cpr_id = p.cpr_id
		AND i.treatment_id = p.treatment_id
		AND i.treatment_progress_sequence = p.treatment_progress_sequence
	WHERE i.progress_type = 'Modify'
	AND i.progress_key IN ('treatment_description', 'treatment_goal')


	-- Update the constituents of created vials when the definition changes
	INSERT INTO p_Treatment_Progress (
			cpr_id,
			treatment_id,
			encounter_id,
			[user_id],
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			attachment_id,
			patient_workplan_item_id,
			risk_level,
			created,
			created_by)
	SELECT tc.cpr_id,
			tc.treatment_id,
			i.encounter_id,
			i.[user_id],
			i.progress_date_time,
			i.progress_type,
			i.progress_key,
			i.progress_value,
			i.attachment_id,
			i.patient_workplan_item_id,
			i.risk_level,
			i.created,
			i.created_by
	FROM p_Treatment_Item tc
		INNER JOIN p_Treatment_item fs
		ON tc.cpr_id = fs.cpr_id
		AND tc.parent_treatment_id = fs.treatment_id
		INNER JOIN p_Treatment_Item td
		ON fs.cpr_id = td.cpr_id
		AND fs.parent_treatment_id = td.parent_treatment_id
		AND ISNULL(tc.drug_id, '!NULL') = ISNULL(td.drug_id, '!NULL')
		INNER JOIN inserted i
		ON td.cpr_id = i.cpr_id
		AND td.treatment_id = i.treatment_id
		INNER JOIN c_Vial_Type vt
		ON fs.vial_type = vt.vial_type
	WHERE tc.treatment_type = 'AllergyVialAllergen'
	AND fs.treatment_type = 'AllergyVialInstance'
	AND td.treatment_type = 'AllergyVialDefinition'
	AND vt.full_strength_ratio = 1
	AND i.progress_type = 'Modify'
	AND i.progress_key = 'dose_amount'

	-- Since recursive triggers may be turned off, go ahead and update the p_Treatment_Item table with this update
	UPDATE tc
	SET dose_amount = CONVERT(real, i.progress_value)
	FROM p_Treatment_Item tc
		INNER JOIN p_Treatment_item fs
		ON tc.cpr_id = fs.cpr_id
		AND tc.parent_treatment_id = fs.treatment_id
		INNER JOIN p_Treatment_Item td
		ON fs.cpr_id = td.cpr_id
		AND fs.parent_treatment_id = td.parent_treatment_id
		AND ISNULL(tc.drug_id, '!NULL') = ISNULL(td.drug_id, '!NULL')
		INNER JOIN inserted i
		ON td.cpr_id = i.cpr_id
		AND td.treatment_id = i.treatment_id
		INNER JOIN c_Vial_Type vt
		ON fs.vial_type = vt.vial_type
	WHERE tc.treatment_type = 'AllergyVialAllergen'
	AND fs.treatment_type = 'AllergyVialInstance'
	AND td.treatment_type = 'AllergyVialDefinition'
	AND vt.full_strength_ratio = 1
	AND i.progress_type = 'Modify'
	AND i.progress_key = 'dose_amount'

END -- Modify_flag > 0

-- Msc add code to not turn the current flag to 'N' for a "Reviewed" progress note even
-- if there's no comment.  This is to handle the fact that some old configs allow
-- users to mark treatments as "Reviewed" without a comment, but those notes must still
-- behave correctly on RTF reports and on the Daily Lab screen.
UPDATE t1
SET current_flag = 'N'
FROM p_Treatment_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.treatment_id = t2.treatment_id
	AND t1.progress_type = t2.progress_type
	AND ISNULL(t1.progress_key, '!NULL') = ISNULL(t2.progress_key, '!NULL')
	AND t1.progress_date_time = t2.progress_date_time
	LEFT OUTER JOIN c_Object_Default_Progress_Type pt
	ON pt.context_object = 'Treatment'
	AND t1.progress_type = pt.progress_type
WHERE (t1.treatment_progress_sequence < t2.treatment_progress_sequence
		OR (t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL AND t1.progress_type <> 'Reviewed' AND t1.progress_type NOT LIKE 'Refill%') )
AND ISNULL(pt.allow_multiple_dates, 'Y') = 'Y'

-- Msc add code to turn the current flag to 'N' regardless of the progress_date_time for a set of
-- progress types specified by the [allow_multiple_dates] column of c_Object_Default_Progress_Type
UPDATE t1
SET current_flag = 'N'
FROM p_Treatment_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.treatment_id = t2.treatment_id
	AND t1.progress_type = t2.progress_type
	AND ISNULL(t1.progress_key, '!NULL') = ISNULL(t2.progress_key, '!NULL')
	LEFT OUTER JOIN c_Object_Default_Progress_Type pt
	ON pt.context_object = 'Treatment'
	AND t1.progress_type = pt.progress_type
WHERE (t1.treatment_progress_sequence < t2.treatment_progress_sequence
		OR (t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL AND t1.progress_type <> 'Reviewed' AND t1.progress_type NOT LIKE 'Refill%') )
AND ISNULL(pt.allow_multiple_dates, 'Y') <> 'Y'

IF @Property_flag > 0
BEGIN
	UPDATE t1
	SET progress_type = 'Modify'
	FROM p_Treatment_Progress t1
		INNER JOIN inserted t2
		ON t1.cpr_id = t2.cpr_id
		AND t1.treatment_id = t2.treatment_id
		AND t1.treatment_progress_sequence = t2.treatment_progress_sequence
	WHERE t1.progress_type = 'Property'
	AND t1.progress_key = 'treatment_description'
END


-- Add a billing record if one doesn't already exist
DECLARE lc_assessments CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
	SELECT DISTINCT i.cpr_id ,
			i.encounter_id,
			pat.problem_id,
			i.created_by,
			i.progress_type
	FROM inserted i
		INNER JOIN p_Assessment_Treatment pat
		ON i.cpr_id = pat.cpr_id
		AND i.treatment_id = pat.treatment_id
	WHERE i.progress_type NOT IN ('Closed', 'Cancelled')

OPEN lc_assessments

FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ls_created_by, @ls_progress_type

WHILE @@FETCH_STATUS = 0
	BEGIN
	
	EXECUTE sp_set_assessment_billing
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@pl_problem_id = @ll_problem_id,
				@ps_bill_flag  = NULL,
				@ps_created_by = @ls_created_by
	
	FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ls_created_by, @ls_progress_type
	END

CLOSE lc_assessments
DEALLOCATE lc_assessments

-- Add/Remove records from p_Assessment_Treatment as necessary
IF @Assessment_flag > 0
	BEGIN
	DELETE t
	FROM p_Assessment_Treatment t
		INNER JOIN inserted i
		ON t.cpr_id = i.cpr_id
		AND t.treatment_id = i.treatment_id
		AND t.problem_id = CAST(i.progress_value AS int)
	WHERE i.progress_type = 'ASSESSMENT'
	AND i.progress_key = 'Disassociate'

	INSERT INTO p_Assessment_Treatment (
		cpr_id,
		problem_id,
		treatment_id,
		encounter_id,
		created,
		created_by)
	SELECT i.cpr_id,
		CAST(i.progress_value AS int),
		i.treatment_id,
		COALESCE(i.encounter_id, t.open_encounter_id),
		i.created,
		i.created_by
	FROM inserted i
		INNER JOIN p_Treatment_Item t
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
	WHERE i.progress_type = 'ASSESSMENT'
	AND i.progress_key = 'Associate'
	AND NOT EXISTS(
		SELECT 1
		FROM p_Assessment_Treatment p1
		WHERE i.cpr_id = p1.cpr_id
		AND CAST(i.progress_value AS int) = p1.problem_id
		AND i.treatment_id = p1.treatment_id )
	END

-- Update the p_Attachment table if this is an attachment
IF (SELECT sum(attachment_id) FROM inserted) > 0
	UPDATE a
	SET context_object = 'Treatment',
		object_key = i.treatment_id
	FROM p_Attachment a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.attachment_id = i.attachment_id
	WHERE i.attachment_id > 0


-- Add records to r_Efficacy_Data
IF @Effectiveness_flag > 0
	BEGIN
	INSERT INTO r_Efficacy_Data (
		clinicaleventid,
		eventdate,
		owner_id,
		assessment_id,
		treatment_type,
		treatment_key,
		effectiveness)
	SELECT i.id,
		dbo.fn_date_truncate(i.progress_date_time, 'DAY'),
		s.customer_id,
		i.progress_key,
		t.treatment_type,
		dbo.fn_treatment_key(i.cpr_id, i.treatment_id),
		i.progress_value
	FROM inserted i
		INNER JOIN p_Treatment_Item t
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
		CROSS JOIN c_Database_Status s
	WHERE i.progress_type = 'Effectiveness'
	AND i.progress_key IS NOT NULL
	AND dbo.fn_treatment_key(i.cpr_id, i.treatment_id) IS NOT NULL
	AND i.progress_value IS NOT NULL
	AND NOT EXISTS(
		SELECT 1
		FROM r_Efficacy_Data r
		WHERE i.id = r.clinicaleventid)
	END


IF @Add_Instruction_flag > 0
	BEGIN
	DECLARE @existinginstructions TABLE (
		[cpr_id] [varchar](12) NOT NULL,
		[treatment_id] [int] NOT NULL,
		[progress_type] [varchar](24) NULL,
		[progress_key] [varchar](40) NULL,
		[progress_value] [varchar](40) NULL,
		[progress] [varchar] (4000) NULL)

	-- Get all the records that have existing instructions.
	INSERT INTO @existinginstructions (
			cpr_id,
			treatment_id,
			progress_type,
			progress_key,
			progress)
	SELECT 	p.cpr_id,
			p.treatment_id,
			p.progress_type,
			p.progress_key,
			RTRIM(COALESCE(CAST(p.progress AS varchar(4000)), p.progress_value, ''))
	FROM p_Treatment_Progress p
		INNER JOIN inserted i
		ON p.cpr_id = i.cpr_id
		AND p.treatment_id = i.treatment_id
		AND p.progress_key = i.progress_key
		INNER JOIN p_Treatment_Progress p2
		ON p2.cpr_id = i.cpr_id
		AND p2.treatment_id = i.treatment_id
		AND p2.treatment_progress_sequence = i.treatment_progress_sequence
	WHERE p.progress_type = 'Instructions'
	AND i.progress_type = 'Add Instructions'
	AND p.current_flag = 'Y'
	AND (p2.progress IS NOT NULL OR p2.progress_value IS NOT NULL)

	-- Make sure each one has a period on the end
	UPDATE x
	SET progress = progress + '.'
	FROM @existinginstructions x
	WHERE RIGHT(progress, 1) <> '.'

	-- Append the "added" instruction to the existing instruction
	UPDATE x
	SET progress = x.progress + '  ' + COALESCE(CAST(p2.progress AS varchar(4000)), p2.progress_value)
	FROM @existinginstructions x
		INNER JOIN inserted i
		ON x.cpr_id = i.cpr_id
		AND x.treatment_id = i.treatment_id
		AND x.progress_key = i.progress_key
		INNER JOIN p_Treatment_Progress p2
		ON p2.cpr_id = i.cpr_id
		AND p2.treatment_id = i.treatment_id
		AND p2.treatment_progress_sequence = i.treatment_progress_sequence


	-- Get all the records that have no existing instructions.  The "added" instruction becomes the new instruction.
	INSERT INTO @existinginstructions (
			cpr_id,
			treatment_id,
			progress_type,
			progress_key,
			progress_value,
			progress)
	SELECT 	p2.cpr_id,
			p2.treatment_id,
			p2.progress_type,
			p2.progress_key,
			p2.progress_value,
			p2.progress
	FROM inserted i
		INNER JOIN p_Treatment_Progress p2
		ON p2.cpr_id = i.cpr_id
		AND p2.treatment_id = i.treatment_id
		AND p2.treatment_progress_sequence = i.treatment_progress_sequence
	WHERE i.progress_type = 'Add Instructions'
	AND i.current_flag = 'Y'
	AND NOT EXISTS (
		SELECT 1
		FROM @existinginstructions x
		WHERE i.cpr_id = x.cpr_id
		AND i.treatment_id = x.treatment_id
		AND i.progress_key = x.progress_key
		)

	-- Update the new combined instructions back to the p_treatment_progress table.
	INSERT INTO p_Treatment_Progress (
			cpr_id,
			treatment_id,
			encounter_id,
			[user_id],
			progress_date_time,
			progress_type,
			progress_key,
			progress_value,
			progress,
			attachment_id,
			patient_workplan_item_id,
			risk_level,
			created,
			created_by)
	SELECT i.cpr_id,
			i.treatment_id,
			i.encounter_id,
			i.[user_id],
			i.progress_date_time,
			x.progress_type,
			x.progress_key,
			x.progress_value,
			x.progress,
			i.attachment_id,
			i.patient_workplan_item_id,
			i.risk_level,
			i.created,
			i.created_by
	FROM inserted i
		INNER JOIN @existinginstructions x
		ON i.cpr_id = x.cpr_id
		AND i.treatment_id = x.treatment_id
		AND i.progress_key = x.progress_key

	END

GO

