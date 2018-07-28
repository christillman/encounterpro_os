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

-- Drop Procedure [dbo].[sp_time_spent_with_patient]
Print 'Drop Procedure [dbo].[sp_time_spent_with_patient]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_time_spent_with_patient]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_time_spent_with_patient]
GO

-- Create Procedure [dbo].[sp_time_spent_with_patient]
Print 'Create Procedure [dbo].[sp_time_spent_with_patient]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_time_spent_with_patient (
	@ps_cpr_id varchar(12),
	@pl_encounter_id int )
AS

DECLARE @items TABLE (
	patient_workplan_item_id int,
	description varchar(80) NOT NULL )

DECLARE @starts TABLE (
	patient_workplan_item_id int NOT NULL,
	user_id varchar(24) NOT NULL,
	started datetime NOT NULL,
	finished datetime NOT NULL,
	item_seconds int NOT NULL,
	encounter_seconds int NULL)

DECLARE @ll_patient_workplan_item_id int,
		@ls_user_id varchar(24),
		@ldt_progress_date_time datetime,
		@ls_progress_type varchar(24),
		@ldt_started datetime,
		@ls_started_user_id varchar(24),
		@ldt_finished datetime,
		@ll_outer_item int,
		@ldt_outer_finished datetime,
		@ls_outer_user_id varchar(24),
		@ll_started_patient_workplan_item_id int

-- Get a list of items in the encounter
INSERT INTO @items (
	patient_workplan_item_id,
	description)
SELECT patient_workplan_item_id,
		ISNULL(description, '<No Description>')
FROM p_Patient_WP_Item
WHERE cpr_id = @ps_cpr_id
AND encounter_id = @pl_encounter_id

DECLARE lc_events CURSOR LOCAL FAST_FORWARD FOR
	SELECT p.patient_workplan_item_id,
		p.user_id,
		p.progress_date_time,
		event = CASE WHEN p.progress_type IN ('Completed', 'DoLater', 'Cancelled', 'Continued') THEN 'Finished'
					ELSE p.progress_type END
	FROM p_Patient_WP_Item_Progress p
		INNER JOIN @items i
		ON p.patient_workplan_item_id = i.patient_workplan_item_id
	WHERE p.cpr_id = @ps_cpr_id
	AND p.encounter_id = @pl_encounter_id
	AND p.progress_type IN ('Started', 'Completed', 'DoLater', 'Cancelled', 'Continued')
	ORDER BY p.patient_workplan_item_id, p.user_id, p.progress_date_time

OPEN lc_events

FETCH lc_events INTO @ll_patient_workplan_item_id,
					@ls_user_id,
					@ldt_progress_date_time,
					@ls_progress_type

SET @ldt_started = NULL
SET @ll_patient_workplan_item_id = NULL

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ll_started_patient_workplan_item_id <> @ll_patient_workplan_item_id
		BEGIN
		-- The service changed so if there is a pending "Started" event within the past 2 hours, assume that it's still
		-- active and count from the started event to the current time
		
		IF DATEDIFF(second, @ldt_started, getdate()) < 7200
			BEGIN
			SET @ldt_finished = getdate()
			
			INSERT INTO @starts (
				patient_workplan_item_id,
				user_id,
				started,
				finished,
				item_seconds,
				encounter_seconds)
			VALUES (
				@ll_started_patient_workplan_item_id,
				@ls_started_user_id,
				@ldt_started,
				@ldt_finished,
				DATEDIFF(second, @ldt_started, @ldt_finished),
				DATEDIFF(second, @ldt_started, @ldt_finished))
			END
		
		SET @ldt_started = NULL
		SET @ls_started_user_id = NULL
		SET @ll_started_patient_workplan_item_id = NULL
		END

	IF @ls_progress_type = 'Started'
		BEGIN
		SET @ldt_started = @ldt_progress_date_time
		SET @ls_started_user_id = @ls_user_id
		SET @ll_started_patient_workplan_item_id = @ll_patient_workplan_item_id
		END
	ELSE
		BEGIN
		IF @ldt_started IS NOT NULL AND @ls_started_user_id = @ls_user_id
			BEGIN
			INSERT INTO @starts (
				patient_workplan_item_id,
				user_id,
				started,
				finished,
				item_seconds,
				encounter_seconds)
			VALUES (
				@ll_patient_workplan_item_id,
				@ls_user_id,
				@ldt_started,
				@ldt_progress_date_time,
				DATEDIFF(second, @ldt_started, @ldt_progress_date_time),
				DATEDIFF(second, @ldt_started, @ldt_progress_date_time))
			END
				
		SET @ldt_started = NULL
		SET @ls_started_user_id = NULL
		SET @ll_started_patient_workplan_item_id = NULL
		END
	
	FETCH lc_events INTO @ll_patient_workplan_item_id,
						@ls_user_id,
						@ldt_progress_date_time,
						@ls_progress_type
	END

CLOSE lc_events
DEALLOCATE lc_events

-- If there is a pending "Started" event within the past 2 hours, assume that it's still
-- active and count from the started event to the current time

IF @ll_started_patient_workplan_item_id IS NOT NULL 
	AND @ls_started_user_id IS NOT NULL
	AND DATEDIFF(second, @ldt_started, getdate()) < 7200
	BEGIN
	SET @ldt_finished = getdate()
	
	INSERT INTO @starts (
		patient_workplan_item_id,
		user_id,
		started,
		finished,
		item_seconds,
		encounter_seconds)
	VALUES (
		@ll_started_patient_workplan_item_id,
		@ls_started_user_id,
		@ldt_started,
		@ldt_finished,
		DATEDIFF(second, @ldt_started, @ldt_finished),
		DATEDIFF(second, @ldt_started, @ldt_finished))
	END


DECLARE lc_times CURSOR LOCAL FAST_FORWARD FOR
	SELECT patient_workplan_item_id,
				user_id,
				started,
				finished
	FROM @starts
	ORDER BY user_id, started, patient_workplan_item_id

OPEN lc_times

SET @ldt_outer_finished = NULL

FETCH lc_times INTO @ll_patient_workplan_item_id,
					@ls_user_id,
					@ldt_started,
					@ldt_finished
WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ldt_outer_finished IS NULL
		BEGIN
		SET @ldt_outer_finished = @ldt_finished
		SET @ls_outer_user_id = @ls_user_id
		END
	ELSE
		IF @ldt_finished <= @ldt_outer_finished AND @ls_outer_user_id = @ls_user_id
			-- This service is contained within another service so don't
			-- count its time in the encounter time
			UPDATE @starts
			SET encounter_seconds = 0
			WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
			AND user_id = @ls_user_id
			AND started = @ldt_started
			AND finished = @ldt_finished
		ELSE
			BEGIN
			SET @ldt_outer_finished = @ldt_finished
			SET @ls_outer_user_id = @ls_user_id
			END
	
	FETCH lc_times INTO @ll_patient_workplan_item_id,
						@ls_user_id,
						@ldt_started,
						@ldt_finished
	END

CLOSE lc_times
DEALLOCATE lc_times

SELECT s.patient_workplan_item_id,
	i.description,
	s.user_id,
	s.started,
	s.finished,
	s.item_seconds,
	s.encounter_seconds,
	u.user_full_name
FROM @starts s
	INNER JOIN @items i
	ON s.patient_workplan_item_id = i.patient_workplan_item_id
	INNER JOIN c_User u
	ON s.user_id = u.user_id
ORDER BY s.user_id, s.started, s.patient_workplan_item_id


GO
GRANT EXECUTE
	ON [dbo].[sp_time_spent_with_patient]
	TO [cprsystem]
GO

