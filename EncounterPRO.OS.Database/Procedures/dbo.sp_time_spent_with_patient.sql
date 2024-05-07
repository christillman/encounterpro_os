
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
		
		IF DATEDIFF(second, @ldt_started, dbo.get_client_datetime()) < 7200
			BEGIN
			SET @ldt_finished = dbo.get_client_datetime()
			
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
	AND DATEDIFF(second, @ldt_started, dbo.get_client_datetime()) < 7200
	BEGIN
	SET @ldt_finished = dbo.get_client_datetime()
	
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
			AND [user_id] = @ls_user_id
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

