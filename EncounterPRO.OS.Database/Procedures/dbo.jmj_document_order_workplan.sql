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

-- Drop Procedure [dbo].[jmj_document_order_workplan]
Print 'Drop Procedure [dbo].[jmj_document_order_workplan]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_document_order_workplan]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_document_order_workplan]
GO

-- Create Procedure [dbo].[jmj_document_order_workplan]
Print 'Create Procedure [dbo].[jmj_document_order_workplan]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_document_order_workplan
	(
	@ps_cpr_id varchar(12),
	@ps_context_object varchar(24),
	@pl_object_key int = NULL,
	@ps_purpose varchar(40),
	@ps_new_object char(1) ,
	@ps_ordered_by varchar(24) ,
	@ps_created_by varchar(24) ,
	@ps_workplan_description varchar(80) = NULL
	)
AS

DECLARE @ll_workplan_id int,
	@ll_encounter_id int,
	@ll_problem_id int,
	@ll_treatment_id int,
	@ll_observation_sequence int,
	@ll_attachment_id int,
	@ls_ordered_for varchar(24),
	@ls_ordered_for_context_object varchar(24),
	@ls_in_office_flag char(1),
	@ls_mode varchar(32),
	@ll_parent_patient_workplan_item_id int,
	@ls_dispatch_flag char(1),
	@ll_patient_workplan_id int,
	@ll_count int,
	@ll_error int,
	@ls_object_ordered_by varchar(24),
	@ll_parent_treatment_id int,
	@ls_suppress char(1)

-- The default context for determining the ordered_for is the passed in context
SET @ls_ordered_for_context_object = @ps_context_object

SET @ls_ordered_for = NULL

IF @ps_context_object = 'Encounter'
	SET @ll_encounter_id = @pl_object_key

IF @ps_context_object = 'Assessment'
	SET @ll_problem_id = @pl_object_key

IF @ps_context_object = 'Treatment'
	SET @ll_treatment_id = @pl_object_key

IF @ps_context_object = 'Attachment'
	BEGIN
	SET @ll_attachment_id = @pl_object_key

	-- For attachments, use the context that the attachment is attached to for
	-- determining the ordered_for	
	SELECT @ll_encounter_id = encounter_id,
			@ll_problem_id = problem_id,
			@ll_treatment_id = treatment_id,
			@ls_ordered_for_context_object = context_object
	FROM p_Attachment
	WHERE attachment_id = @ll_attachment_id
	END


-- Now get the ordered_for based on the previous info gathered
IF @ls_ordered_for_context_object = 'Encounter'
	BEGIN
	SET @ll_encounter_id = @pl_object_key
	
	SELECT @ls_ordered_for = attending_doctor
	FROM p_Patient_Encounter
	WHERE cpr_id = @ps_cpr_id
	AND encounter_id = @ll_encounter_id
	
	SELECT @ll_count = @@ROWCOUNT, @ll_error = @@ERROR
	
	IF @ll_error <> 0
		RETURN -1
	
	IF @ll_count = 0
		BEGIN
		RAISERROR ('Encounter not found (%s,%d)',16,-1, @ps_cpr_id, @ll_encounter_id)
		RETURN -1
		END
	END

IF @ls_ordered_for_context_object = 'Assessment'
	BEGIN
	SET @ll_problem_id = @pl_object_key
	
	SELECT @ls_ordered_for = diagnosed_by
	FROM p_Assessment
	WHERE cpr_id = @ps_cpr_id
	AND problem_id = @ll_problem_id
	AND current_flag = 'Y'
	
	SELECT @ll_count = @@ROWCOUNT, @ll_error = @@ERROR
	
	IF @ll_error <> 0
		RETURN -1
	
	IF @ll_count = 0
		BEGIN
		RAISERROR ('Assessment not found (%s,%d)',16,-1, @ps_cpr_id, @ll_problem_id)
		RETURN -1
		END
	END

IF @ls_ordered_for_context_object = 'Treatment'
	BEGIN
	SET @ll_treatment_id = @pl_object_key
	SELECT @ls_ordered_for = ordered_for,
			@ls_object_ordered_by = ordered_by,
			@ll_parent_treatment_id = parent_treatment_id
	FROM p_Treatment_item
	WHERE cpr_id = @ps_cpr_id
	AND treatment_id = @ll_treatment_id
	
	SELECT @ll_count = @@ROWCOUNT, @ll_error = @@ERROR
	
	IF @ll_error <> 0
		RETURN -1
	
	IF @ll_count = 0
		BEGIN
		RAISERROR ('Treatment not found (%s,%d)',16,-1, @ps_cpr_id, @ll_treatment_id)
		RETURN -1
		END

	-- If the ordered_for isn't a valid user, then try the ordered_by
	IF NOT EXISTS (SELECT 1 FROM c_User 
					WHERE user_id = @ls_ordered_for
					AND actor_class = 'User')
		BEGIN
		SET @ls_ordered_for = @ls_object_ordered_by

		-- If the ordered_by isn't a valid user, try the ordered_for of the parent treatment
		IF NOT EXISTS (SELECT 1 FROM c_User 
						WHERE user_id = @ls_ordered_for
						AND actor_class = 'User')
			BEGIN
			SELECT @ls_ordered_for = ordered_for,
					@ls_object_ordered_by = ordered_by
			FROM p_Treatment_item
			WHERE cpr_id = @ps_cpr_id
			AND treatment_id = @ll_parent_treatment_id

			-- If the parent treatment ordered_for isn't a valid user, try the ordered_fby of the parent treatment
			IF NOT EXISTS (SELECT 1 FROM c_User 
							WHERE user_id = @ls_ordered_for
							AND actor_class = 'User')
				BEGIN
				SET @ls_ordered_for = @ls_object_ordered_by
				END

			END
		END
	END


-- If we still don't have a valid user, then just use whoever is ordering this workplan
IF NOT EXISTS (SELECT 1 FROM c_User 
				WHERE user_id = @ls_ordered_for
				AND actor_class = 'User')
	BEGIN
	SET @ls_ordered_for = @ps_ordered_by
	END

-- Get the workplan from the document purpose table

SELECT @ll_workplan_id = CASE @ps_new_object WHEN 'Y' THEN new_object_workplan_id ELSE existing_object_workplan_id END
FROM c_Document_Purpose
WHERE context_object = @ps_context_object
AND purpose = @ps_purpose

SELECT @ll_count = @@ROWCOUNT, @ll_error = @@ERROR

IF @ll_error <> 0
	RETURN -1

IF @ll_count = 0
	RETURN

IF @ps_workplan_description IS NULL
	SET @ps_workplan_description = @ps_purpose


SET @ls_suppress = 'N'
IF @ps_workplan_description LIKE 'Sending%SureScripts%Succeeded%' AND @ps_purpose = 'Message Success'
	BEGIN
	-- This is a SureScripts success message.  There is a specific preference to control those
	-- as a hack-workaround for customers doing e-Rx before Server 7.2.x
	SET @ls_suppress = ISNULL(LEFT(dbo.fn_get_preference('WORKFLOW', 'Suppress SureScripts Success Messages', NULL, NULL), 1), 'Y')
	IF @ls_suppress IN ('Y', 'T')
		SET @ls_suppress = 'Y'
	END

IF @ls_suppress = 'Y'
	SET @ll_patient_workplan_id = NULL
ELSE
	BEGIN
	EXECUTE sp_Order_Workplan
		@ps_cpr_id = @ps_cpr_id,
		@pl_workplan_id = @ll_workplan_id,
		@pl_encounter_id = @ll_encounter_id,
		@pl_problem_id = @ll_problem_id,
		@pl_treatment_id = @ll_treatment_id,
		@pl_attachment_id = @ll_attachment_id,
		@ps_description = @ps_workplan_description,
		@ps_ordered_by = @ps_ordered_by,
		@ps_ordered_for = @ls_ordered_for,
		@ps_created_by = @ps_created_by,
		@pl_patient_workplan_id = @ll_patient_workplan_id OUTPUT

	IF @@ERROR <> 0
		RETURN -1
	END

RETURN @ll_patient_workplan_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_document_order_workplan]
	TO [cprsystem]
GO

