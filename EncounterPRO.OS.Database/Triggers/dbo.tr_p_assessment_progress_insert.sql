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

-- Drop Trigger [dbo].[tr_p_assessment_progress_insert]
Print 'Drop Trigger [dbo].[tr_p_assessment_progress_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_p_assessment_progress_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_p_assessment_progress_insert]
GO

-- Create Trigger [dbo].[tr_p_assessment_progress_insert]
Print 'Create Trigger [dbo].[tr_p_assessment_progress_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER tr_p_assessment_progress_insert ON dbo.p_Assessment_Progress
FOR INSERT
AS
IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_cpr_id varchar(12) ,
		@ll_problem_id int ,
		@ll_treatment_id int ,
		@ls_progress_type varchar(24),
		@ls_progress_value varchar(40),
		@ll_encounter_id int,
		@ls_user_id varchar(24),
		@ls_created_by varchar(24),
		@ls_bill_flag char(1)

DECLARE
	 @ATTACHMENT_FOLDER_flag SMALLINT
	,@ATTACHMENT_TAG_flag SMALLINT
	,@Canceled_flag SMALLINT
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
	 @ATTACHMENT_FOLDER_flag = SUM( CHARINDEX( 'ATTACHMENT_FOLDER', inserted.progress_type ) )
	,@ATTACHMENT_TAG_flag = SUM( CHARINDEX( 'ATTACHMENT_TAG', inserted.progress_type ) )
	,@Canceled_flag = SUM( CHARINDEX( 'Canceled', inserted.progress_type ) )
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
	UPDATE a
	SET	default_grant = CASE i.progress_key WHEN 'Allow' THEN 1 
												WHEN 'Deny' THEN 0 
												ELSE a.default_grant END
	FROM p_Assessment a
		INNER JOIN inserted i
		ON i.cpr_id = a.cpr_id
		AND i.problem_id = a.problem_id
		AND i.diagnosis_sequence = a.diagnosis_sequence
	WHERE i.progress_type = 'CONFIDENTIAL'
	END

-- Update Status
IF @CLOSED_flag > 0 OR @CANCELLED_flag > 0 OR @REDIAGNOSED_flag > 0
BEGIN
	UPDATE p_Assessment
	SET	assessment_status = inserted.progress_type,
		end_date = inserted.progress_date_time,
		close_encounter_id = inserted.encounter_id
	FROM inserted
	WHERE inserted.cpr_id = p_Assessment.cpr_id
	AND inserted.problem_id = p_Assessment.problem_id
	AND inserted.diagnosis_sequence = p_Assessment.diagnosis_sequence
	AND inserted.progress_type in ('CLOSED', 'CANCELLED', 'REDIAGNOSED')
	AND (p_Assessment.assessment_status IS NULL
	OR p_Assessment.end_date < inserted.progress_date_time)
END

-- Update Status
IF @UNCANCELLED_flag > 0
BEGIN
	UPDATE p_Assessment
	SET	assessment_status = NULL,
		end_date = NULL,
		close_encounter_id = NULL
	FROM inserted
	WHERE inserted.cpr_id = p_Assessment.cpr_id
	AND inserted.problem_id = p_Assessment.problem_id
	AND inserted.diagnosis_sequence = p_Assessment.diagnosis_sequence
	AND inserted.progress_type in ('UNCancelled')
	AND p_Assessment.assessment_status = 'Cancelled'
END

-- Modify assessment field
IF @Modify_flag > 0
BEGIN
	UPDATE p_Assessment
	SET assessment = CASE inserted.progress_key WHEN 'assessment' then inserted.progress_value ELSE p_Assessment.assessment END,
		acuteness = CASE inserted.progress_key WHEN 'acuteness' then inserted.progress_value ELSE p_Assessment.acuteness END,
		begin_date = CASE inserted.progress_key WHEN 'begin_date' then CONVERT(datetime, inserted.progress_value) ELSE p_Assessment.begin_date END,
		end_date = CASE inserted.progress_key WHEN 'end_date' then CONVERT(datetime, inserted.progress_value) ELSE p_Assessment.end_date END,
		risk_level = CASE inserted.progress_key WHEN 'risk_level' then CONVERT(int, inserted.progress_value) ELSE p_Assessment.risk_level END
	FROM inserted
	WHERE inserted.cpr_id = p_Assessment.cpr_id
	AND inserted.problem_id = p_Assessment.problem_id
	AND inserted.diagnosis_sequence = p_Assessment.diagnosis_sequence
	AND inserted.progress_type = 'Modify'
END

UPDATE t1
SET current_flag = 'N'
FROM p_Assessment_Progress t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.problem_id = t2.problem_id
	AND t1.progress_type = t2.progress_type
	AND t1.progress_key = t2.progress_key
	AND t1.progress_date_time = t2.progress_date_time
WHERE t1.assessment_progress_sequence < t2.assessment_progress_sequence
OR (t1.progress_key IS NOT NULL AND t1.progress_value IS NULL AND t1.progress IS NULL AND t1.attachment_id IS NULL)

	
-- Add a billing record if one doesn't already exist
DECLARE lc_assessments CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
	SELECT DISTINCT cpr_id ,
			encounter_id,
			problem_id,
			created_by,
			progress_type,
			progress_value
	FROM inserted

OPEN lc_assessments

FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ls_created_by, @ls_progress_type, @ls_progress_value

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_bill_flag = CASE @ls_progress_type	WHEN 'Closed' THEN 'X' 
												WHEN 'Cancelled' THEN 'N'
												WHEN 'Bill' THEN @ls_progress_value
												ELSE NULL END
	
	EXECUTE sp_set_assessment_billing
				@ps_cpr_id = @ls_cpr_id,
				@pl_encounter_id = @ll_encounter_id,
				@pl_problem_id = @ll_problem_id,
				@ps_bill_flag  = @ls_bill_flag,
				@ps_created_by = @ls_created_by
	
	FETCH lc_assessments INTO @ls_cpr_id, @ll_encounter_id, @ll_problem_id, @ls_created_by, @ls_progress_type, @ls_progress_value
	END

CLOSE lc_assessments
DEALLOCATE lc_assessments


IF @CLOSED_flag > 0 OR @CANCELLED_flag > 0
	BEGIN
	DECLARE @close_treatments TABLE (
		cpr_id varchar(12) NOT NULL,
		problem_id int NOT NULL,
		treatment_id int NOT NULL,
		progress_type varchar(24) NOT NULL ,
		encounter_id int NULL,
		user_id varchar(24) NOT NULL,
		created_by varchar(24) NOT NULL )
	
	-- Get a list of the treatments still open for the closed assessments
	-- If the client specified a progress_key, then the client will be
	-- taking care of closing the treatments so don't do it here
	INSERT INTO @close_treatments (
		cpr_id ,
		problem_id ,
		treatment_id,
		progress_type,
		encounter_id,
		user_id,
		created_by )
	SELECT a.cpr_id,
		a.problem_id,
		a.treatment_id,
		i.progress_type,
		i.encounter_id,
		i.user_id,
		i.created_by
	FROM inserted i
		INNER JOIN p_Assessment_Treatment a
		ON i.cpr_id = a.cpr_id
		AND i.problem_id = a.problem_id
		INNER JOIN p_Treatment_Item t
		ON a.cpr_id = t.cpr_id
		AND a.treatment_id = t.treatment_id
	WHERE i.progress_type IN ('Closed', 'Cancelled')
	AND i.progress_key IS NULL
	AND ISNULL(t.treatment_status, 'Open') = 'Open'
	
	-- Delete the treatments which are associated with another open assessment
	DELETE t
	FROM @close_treatments t
		INNER JOIN p_Assessment_Treatment a
		ON t.cpr_id = a.cpr_id
		AND t.treatment_id = a.treatment_id
		INNER JOIN p_Assessment p
		ON a.cpr_id = p.cpr_id
		AND a.problem_id = p.problem_id
	WHERE a.problem_id <> t.problem_id
	AND p.current_flag = 'Y'
	AND ISNULL(p.assessment_status, 'Open') = 'Open'
	
	DECLARE lc_treatments CURSOR LOCAL STATIC FORWARD_ONLY TYPE_WARNING FOR
		SELECT cpr_id ,
				problem_id ,
				treatment_id,
				progress_type,
				encounter_id,
				user_id,
				created_by
		FROM @close_treatments
	
	OPEN lc_treatments
	
	FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ls_progress_type, @ll_encounter_id, @ls_user_id, @ls_created_by
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- Close the treatment
		EXECUTE sp_set_treatment_progress
					@ps_cpr_id = @ls_cpr_id,
					@pl_treatment_id = @ll_treatment_id,
					@pl_encounter_id = @ll_encounter_id,
					@ps_progress_type = @ls_progress_type,
					@ps_user_id = @ls_user_id,
					@ps_created_by = @ls_created_by
		
		FETCH lc_treatments INTO @ls_cpr_id, @ll_problem_id, @ll_treatment_id, @ls_progress_type, @ll_encounter_id, @ls_user_id, @ls_created_by
		END
	
	CLOSE lc_treatments
	DEALLOCATE lc_treatments
	
	
	END


IF (SELECT sum(attachment_id) FROM inserted) > 0
	UPDATE a
	SET context_object = 'Assessment',
		object_key = i.problem_id
	FROM p_Attachment a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.attachment_id = i.attachment_id
	WHERE i.attachment_id > 0

GO

