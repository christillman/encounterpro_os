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

-- Drop Procedure [dbo].[sp_set_treatment_progress]
Print 'Drop Procedure [dbo].[sp_set_treatment_progress]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_set_treatment_progress]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_set_treatment_progress]
GO

-- Create Procedure [dbo].[sp_set_treatment_progress]
Print 'Create Procedure [dbo].[sp_set_treatment_progress]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_set_treatment_progress (
	@ps_cpr_id varchar(12),
	@pl_treatment_id integer,
	@pl_encounter_id integer,
	@ps_progress_type varchar(24),
	@ps_progress_key varchar(40) = NULL,
	@ps_progress text = NULL,
	@pdt_progress_date_time datetime = NULL,
	@pl_patient_workplan_item_id integer = NULL,
	@pl_risk_level int = NULL,
	@pl_attachment_id int = NULL,
	@ps_user_id varchar(24),
	@ps_created_by varchar(24) )
AS
DECLARE @ll_encounter_log_id integer,
	@li_encounter_count smallint,
	@ls_status varchar(12),
	@ll_patient_workplan_id int,
	@ls_progress_value varchar(40),
	@ll_length int,
	@ll_patient_workplan_item_id int


-- mark 11/25/03 Added fix for problem of missing (cancelled) PFSH
-- The bug results in a cancelled progress note being reported when the treatment should remain open
DECLARE @ll_bug_count int,
		@ls_bug_progress varchar(12)

SET @ls_bug_progress = CAST(@ps_progress AS varchar(12))
IF @ps_progress_type = 'Cancelled' AND @ls_bug_progress = 'No Results'
	BEGIN
	SELECT @ll_bug_count = count(*)
	FROM p_patient_wp
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	AND workplan_id > 0
	
	-- If there is a real workplan associated with this treatment, then we're not going to allow
	-- a 'No Results' cancel record.
	IF @ll_bug_count > 0
		RETURN
	
	END



IF @pdt_progress_date_time IS NULL
	BEGIN
	IF @ps_progress_type = 'Property'
		BEGIN
		-- If the progress_date_time is null and the progress_type is 'Property' then we want to
		-- assume the previous property progress_date_time for the same key
		SELECT @pdt_progress_date_time = max(progress_date_time)
		FROM p_Treatment_Progress
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND progress_type = @ps_progress_type
		AND progress_key = @ps_progress_key
		END
	
	-- If it's still null, then if it's a realtime encounter, then use the current datetime.
	-- Otherwise, use the encounter date
	IF @pdt_progress_date_time IS NULL
		SET @pdt_progress_date_time = dbo.get_client_datetime()
	END

-- If we're refilling a modified treatment, then apply the refill to the latest treatment
IF @ps_progress_type = 'Refill'
	IF EXISTS(	SELECT 1 FROM p_Treatment_Item t
				WHERE t.cpr_id = @ps_cpr_id
				AND t.treatment_id = @pl_treatment_id
				AND t.treatment_status = 'MODIFIED'
				AND t.end_date < @pdt_progress_date_time)
		SET @pl_treatment_id = dbo.fn_get_current_treatment(@ps_cpr_id, @pl_treatment_id)

-- First add the progress record.  If the length of @ps_progress is <= 40 then
-- store the value in [progress_value].  Otherwise store it in [progress].
SET @ll_length = LEN(CONVERT(varchar(50), @ps_progress))

IF @ll_length <= 40
	BEGIN
	SET @ls_progress_value = CONVERT(varchar(40), @ps_progress)

	INSERT INTO p_Treatment_Progress (
		cpr_id,
		treatment_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress_value,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_treatment_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ls_progress_value,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		@pl_attachment_id,
		dbo.get_client_datetime(),
		@ps_created_by )
	END
ELSE
	INSERT INTO p_Treatment_Progress (
		cpr_id,
		treatment_id,
		encounter_id,
		user_id,
		progress_date_time,
		progress_type,
		progress_key,
		progress,
		patient_workplan_item_id,
		risk_level,
		attachment_id,
		created,
		created_by)
	VALUES (@ps_cpr_id,
		@pl_treatment_id,
		@pl_encounter_id,
		@ps_user_id,
		@pdt_progress_date_time,
		@ps_progress_type,
		@ps_progress_key,
		@ps_progress,
		@pl_patient_workplan_item_id,
		@pl_risk_level,
		@pl_attachment_id,
		dbo.get_client_datetime(),
		@ps_created_by )


-- Delete charge if cancelled
IF @ps_progress_type = 'CANCELLED'
BEGIN
	DELETE p_Encounter_Charge
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @pl_encounter_id
	AND treatment_id = @pl_treatment_id
END
-- Change the status before passing to workplan
IF @ps_progress_type = 'CLOSED' 
	SET @ps_progress_type = 'COMPLETED'

IF @ps_progress_type = 'COMPLETED' OR @ps_progress_type = 'CANCELLED'
	BEGIN

	DECLARE lc_cancel_or_close_wp CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
		SELECT patient_workplan_id
		FROM p_Patient_WP
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND workplan_type = 'Treatment'
		AND status NOT IN('COMPLETED','CANCELLED')

	OPEN lc_cancel_or_close_wp

	FETCH NEXT FROM lc_cancel_or_close_wp INTO @ll_patient_workplan_id
	WHILE (@@fetch_status<>-1)
		BEGIN
		EXECUTE sp_set_workplan_status
			@ps_cpr_id = @ps_cpr_id,
			@pl_encounter_id = @pl_encounter_id,
			@pl_treatment_id = @pl_treatment_id,
			@pl_patient_workplan_id = @ll_patient_workplan_id,
			@ps_progress_type = @ps_progress_type,
			@pdt_progress_date_time = @pdt_progress_date_time,
			@ps_completed_by = @ps_user_id,
			@ps_created_by = @ps_created_by

		FETCH NEXT FROM lc_cancel_or_close_wp INTO @ll_patient_workplan_id
		END

	CLOSE lc_cancel_or_close_wp
	DEALLOCATE lc_cancel_or_close_wp

	END

-- Cancel any remaining workplan items for the cancelled treatment
IF @ps_progress_type = 'CANCELLED'
	BEGIN

	DECLARE lc_cancel_trt CURSOR LOCAL FAST_FORWARD TYPE_WARNING FOR
		SELECT patient_workplan_item_id
		FROM p_Patient_WP_Item
		WHERE cpr_id = @ps_cpr_id
		AND treatment_id = @pl_treatment_id
		AND status NOT IN('COMPLETED','CANCELLED','Skipped')

	OPEN lc_cancel_trt

	FETCH NEXT FROM lc_cancel_trt INTO @ll_patient_workplan_item_id
	WHILE (@@fetch_status<>-1)
		BEGIN
		EXECUTE sp_set_workplan_item_progress
			@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
			@ps_user_id = @ps_user_id,
			@ps_progress_type = 'Cancelled',
			@ps_created_by = @ps_created_by

		FETCH NEXT FROM lc_cancel_trt INTO @ll_patient_workplan_item_id
		END

	CLOSE lc_cancel_trt
	DEALLOCATE lc_cancel_trt

	END



-- Now check to see if this is an attachment, and, if so, what folder it should go in	
DECLARE	@ls_folder varchar(40),
		@ps_context_object_type varchar(40)

IF @pl_attachment_id IS NOT NULL
	BEGIN
	SELECT @ps_context_object_type = treatment_type
	FROM p_Treatment_Item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @pl_treatment_id
	
	SELECT @ls_folder = min(folder)
	FROM c_Folder
	WHERE context_object = 'Treatment'
	AND context_object_type = @ps_context_object_type

	IF @ls_folder IS NOT NULL
		UPDATE p_Attachment
		SET attachment_folder = @ls_folder
		WHERE attachment_id = @pl_attachment_id
		AND attachment_folder IS NULL

	END	
GO
GRANT EXECUTE
	ON [dbo].[sp_set_treatment_progress]
	TO [cprsystem]
GO

