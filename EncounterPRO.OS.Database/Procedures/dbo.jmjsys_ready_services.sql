DROP PROCEDURE [jmjsys_ready_services]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [jmjsys_ready_services]
(
	@ps_user_id varchar(24)
)
AS

-- This procedure gets the pending todo items for the specified server [user_id] (i.e. #JMJ)
-- Before returning the outstanding todo items, we first check to see if any scheduled items need to be ordered.
-- If so, then they get ordered here and returned as part of the ready services

SET NOCOUNT ON

DECLARE @ll_patient_workplan_item_id int,
		@ls_document_sender_user_id varchar(24),
		@ls_document_poster_user_id varchar(24),
		@ls_receiver_user_id varchar(24),
		@ldt_last_wait_check datetime,
		@ll_count int,
		@ll_wait_count int,
		@ll_wait_count_warning int,
		@ldt_current_datetime datetime,
		@ls_temp varchar(255),
		@ls_transportdescription varchar(80),
		@lr_freq float,
		@ldt_lastreceived datetime,
		@ldt_lastrun datetime,
		@ll_customer_id int,
		@ls_component_id varchar(24),
		@ll_interfaceserviceid int,
		@ll_transportsequence int,
		@ll_error int,
		@ll_rowcount int,
		@ll_sort_sequence int,
		@ll_workplan_sequence int,
		@ls_today varchar(32),
		@ldt_today datetime,
		@ll_service_sequence int,
		@ls_service varchar(24),
		@ls_description varchar(80)

DECLARE @services TABLE (
	patient_workplan_item_id int,
	item_type varchar(12) NOT NULL,
	ordered_service varchar(24),
	in_office_flag char(1),
	ordered_by varchar(24),
	description varchar(80),
	dispatch_date datetime,
	begin_date datetime,
	end_date datetime,
	status varchar(12),
	retries smallint,
	escalation_date datetime,
	expiration_date datetime,
	dispatch_minutes int,
	priority int NULL,
	ready int NOT NULL,
	context_object varchar(24) NULL,
	cpr_id varchar(12) NULL ,
	encounter_id int NULL,
	problem_id int NULL,
	treatment_id int NULL,
	attachment_id int NULL,
	interfaceserviceid int NULL,
	transportsequence int NULL )

SET @ls_today = convert(varchar(10),getdate(), 101)
SET @ldt_today = CAST(@ls_today AS datetime)

SELECT @ll_customer_id = customer_id
FROM c_database_status

-------------------------------------------------------------------------------------
-- See if this is the system user that is supposed to handle the document sending
-------------------------------------------------------------------------------------
SET @ls_document_sender_user_id = dbo.fn_get_global_preference('SERVERCONFIG', 'Document Sender user_id')
IF @ls_document_sender_user_id IS NULL
	SET @ls_document_sender_user_id = '#JMJ'

-- If so then get all the ready documents too
IF @ls_document_sender_user_id = @ps_user_id
	BEGIN
	INSERT INTO @services (
		patient_workplan_item_id ,
		item_type,
		ordered_service ,
		in_office_flag ,
		ordered_by ,
		description ,
		dispatch_date ,
		begin_date ,
		end_date ,
		status ,
		retries ,
		escalation_date ,
		expiration_date ,
		dispatch_minutes ,
		priority ,
		ready ,
		context_object,
		cpr_id,
		encounter_id,
		problem_id ,
		treatment_id ,
		attachment_id )
	SELECT
		i.patient_workplan_item_id,
		i.item_type,
		i.ordered_service,
		i.in_office_flag,
		i.ordered_by,
		i.description,
		i.dispatch_date,
		i.begin_date,
		i.end_date,
		i.status,
		i.retries,
		i.escalation_date,
		i.expiration_date,
		dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
		i.priority,
		1 as ready,
		i.context_object,
		i.cpr_id,
		i.encounter_id,
		i.problem_id ,
		i.treatment_id ,
		i.attachment_id 
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.item_type = 'Document'
	AND 	i.status = 'Ready'

	-- Add the "Create Now" documents
	INSERT INTO @services (
		patient_workplan_item_id ,
		item_type,
		ordered_service ,
		in_office_flag ,
		ordered_by ,
		description ,
		dispatch_date ,
		begin_date ,
		end_date ,
		status ,
		retries ,
		escalation_date ,
		expiration_date ,
		dispatch_minutes ,
		priority ,
		ready ,
		context_object,
		cpr_id,
		encounter_id,
		problem_id ,
		treatment_id ,
		attachment_id )
	SELECT
		i.patient_workplan_item_id,
		'CREATEDOC',
		i.ordered_service,
		i.in_office_flag,
		i.ordered_by,
		i.description,
		i.dispatch_date,
		i.begin_date,
		i.end_date,
		i.status,
		i.retries,
		i.escalation_date,
		i.expiration_date,
		dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
		i.priority,
		1 as ready,
		i.context_object,
		i.cpr_id,
		i.encounter_id,
		i.problem_id ,
		i.treatment_id ,
		i.attachment_id 
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.item_type = 'Document'
	AND 	i.status = 'Creating'
	END

-------------------------------------------------------------------------------------
-- See if this is the system user that is supposed to handle the document posting
-------------------------------------------------------------------------------------
SET @ls_document_poster_user_id = dbo.fn_get_global_preference('SERVERCONFIG', 'Document Poster user_id')
IF @ls_document_poster_user_id IS NULL
	SET @ls_document_poster_user_id = '#JMJ'

IF @ls_document_poster_user_id = @ps_user_id
	BEGIN
	INSERT INTO @services (
		patient_workplan_item_id ,
		item_type,
		ordered_service ,
		in_office_flag ,
		ordered_by ,
		description ,
		dispatch_date ,
		begin_date ,
		end_date ,
		status ,
		retries ,
		escalation_date ,
		expiration_date ,
		dispatch_minutes ,
		priority ,
		ready ,
		context_object,
		cpr_id,
		encounter_id,
		problem_id ,
		treatment_id ,
		attachment_id )
	SELECT
		i.patient_workplan_item_id,
		i.item_type,
		i.ordered_service,
		i.in_office_flag,
		i.ordered_by,
		i.description,
		i.dispatch_date,
		i.begin_date,
		i.end_date,
		i.status,
		i.retries,
		i.escalation_date,
		i.expiration_date,
		dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
		i.priority,
		1 as ready,
		i.context_object,
		i.cpr_id,
		i.encounter_id,
		i.problem_id ,
		i.treatment_id ,
		i.attachment_id 
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.item_type = 'Incoming'
	AND 	i.status = 'Ready'
	END

---------------------------------------------------------------------
-- Order a service for any Scheduled Services that should be run now
---------------------------------------------------------------------
-- Order any scheduled services that are not running and have reached their next runtime
DECLARE lc_schedule CURSOR LOCAL FAST_FORWARD FOR
	SELECT service_sequence
	FROM dbo.fn_scheduled_services()
	WHERE [user_id] = @ps_user_id
	AND running_status = 'Not Running'
	AND status = 'OK'
	AND next_run_date < getdate()

OPEN lc_schedule

FETCH lc_schedule INTO @ll_service_sequence
WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE dbo.jmj_run_scheduled_service
		@pl_service_sequence = @ll_service_sequence,
		@ps_ordered_by = '#SYSTEM',
		@ps_created_by = '#SYSTEM'

	FETCH lc_schedule INTO @ll_service_sequence
	END

CLOSE lc_schedule
DEALLOCATE lc_schedule



-- See if this is the system user that is supposed to handle the document receiving
SET @ls_receiver_user_id = dbo.fn_get_global_preference('SERVERCONFIG', 'Document Receiver user_id')
IF @ls_receiver_user_id IS NULL
	SET @ls_receiver_user_id = '#JMJ'

-- If so then get all the ready documents too
IF @ls_receiver_user_id = @ps_user_id
	BEGIN
	DECLARE lc_transports CURSOR LOCAL FAST_FORWARD FOR
		SELECT r.interfaceserviceid,
				r.transportsequence,
				r.commcomponent,
				r.freq,
				r.lastreceived,
				r.lastrun,
				r.transportdescription
		FROM c_Component_Interface_Route r
			INNER JOIN c_Component_Registry c
			ON r.commcomponent = c.component_id
		WHERE r.subscriber_owner_id = @ll_customer_id
		AND r.direction = 'I'
		AND r.status = 'OK'
		AND c.status = 'OK'
		AND DATEADD(Second, CAST((3600 * r.freq) AS int), ISNULL(r.lastrun, '1/1/2000')) < getdate()

	OPEN lc_transports

	FETCH lc_transports INTO @ll_interfaceserviceid, @ll_transportsequence, @ls_component_id, @lr_freq, @ldt_lastreceived, @ldt_lastrun, @ls_transportdescription
	WHILE @@FETCH_STATUS = 0
		BEGIN
		-- See if there is already an open workplan item for this transport
		IF NOT EXISTS(
			SELECT 1
			FROM p_Patient_WP_Item
			WHERE 	item_type = 'Receiver'
			AND 	status IN ('Dispatched', 'Started')
			AND workplan_id = @ll_interfaceserviceid
			AND item_number = @ll_transportsequence
			)
			BEGIN
			-- Order a new workplan item for this transport
			INSERT INTO p_Patient_WP_Item
				(
				patient_workplan_id,
				workplan_id,
				item_number,
				item_type,
				description,
				status,
				dispatch_date,
				ordered_by,
				ordered_for,
				created_by)
			VALUES	(
				0,
				@ll_interfaceserviceid,  -- repurposeing workplan_id and item_number to hold the interface/route that this document came through
				@ll_transportsequence,
				'Receiver',
				@ls_transportdescription,
				'Dispatched',
				getdate(),
				'#SYSTEM',
				@ps_user_id,
				'#SYSTEM' )


			SELECT @ll_error = @@ERROR,
					@ll_rowcount = @@ROWCOUNT

			IF @ll_error <> 0
				BEGIN
				RETURN -1
				END

			SET @ll_patient_workplan_item_id = SCOPE_IDENTITY()


			END

		FETCH lc_transports INTO @ll_interfaceserviceid, @ll_transportsequence, @ls_component_id, @lr_freq, @ldt_lastreceived, @ldt_lastrun, @ls_transportdescription
		END

	CLOSE lc_transports
	DEALLOCATE lc_transports

	INSERT INTO @services (
		patient_workplan_item_id ,
		item_type,
		ordered_service ,
		in_office_flag ,
		ordered_by ,
		description ,
		dispatch_date ,
		begin_date ,
		end_date ,
		status ,
		retries ,
		escalation_date ,
		expiration_date ,
		dispatch_minutes ,
		priority ,
		ready ,
		context_object,
		cpr_id,
		encounter_id,
		problem_id ,
		treatment_id ,
		attachment_id ,
		interfaceserviceid ,
		transportsequence )
	SELECT
		i.patient_workplan_item_id,
		i.item_type,
		i.ordered_service,
		i.in_office_flag,
		i.ordered_by,
		i.description,
		i.dispatch_date,
		i.begin_date,
		i.end_date,
		i.status,
		i.retries,
		i.escalation_date,
		i.expiration_date,
		dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
		i.priority,
		1 as ready,
		i.context_object,
		i.cpr_id,
		i.encounter_id,
		i.problem_id ,
		i.treatment_id ,
		i.attachment_id ,
		i.workplan_id,
		i.item_number
	FROM p_Patient_WP_Item i WITH (NOLOCK)
	WHERE 	i.item_type = 'Receiver'
	AND 	i.status IN ('Dispatched', 'Started')
	END


INSERT INTO @services (
	patient_workplan_item_id ,
	item_type,
	ordered_service ,
	in_office_flag ,
	ordered_by ,
	description ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	retries ,
	escalation_date ,
	expiration_date ,
	dispatch_minutes ,
	priority ,
	ready ,
	context_object ,
	cpr_id,
	encounter_id,
	problem_id ,
	treatment_id ,
	attachment_id )
SELECT
	i.patient_workplan_item_id,
	i.item_type,
	i.ordered_service,
	i.in_office_flag,
	i.ordered_by,
	i.description,
	i.dispatch_date,
	i.begin_date,
	i.end_date,
	i.status,
	i.retries,
	i.escalation_date,
	i.expiration_date,
	dispatch_minutes = DATEDIFF(minute, i.dispatch_date, getdate()),
	i.priority,
	CASE i.ordered_service WHEN 'WAIT' THEN 0 ELSE 1 END,
	i.context_object,
	i.cpr_id,
	i.encounter_id,
	i.problem_id ,
	i.treatment_id ,
	i.attachment_id 
FROM p_Patient_WP_Item i WITH (NOLOCK)
WHERE 	i.item_type = 'Service'
AND		i.owned_by = @ps_user_id
AND 	i.active_service_flag = 'Y'

-- Don't retry with a minute of a previous attempt
UPDATE s
SET ready = 0
FROM @services s
WHERE EXISTS (
	SELECT 1
	FROM p_Patient_WP_Item_Progress p
	WHERE s.patient_workplan_item_id = p.patient_workplan_item_id
	AND p.progress_type IN ('CLICKED', 'STARTED', 'Sending', 'Starting')
	AND p.progress_date_time > DATEADD(minute, -1, getdate()) )


-- Turn on WAIT ready flag if we think the service is ready to complete

SET @ldt_current_datetime = getdate()

SELECT @ldt_last_wait_check = last_updated 
FROM c_Table_Update
WHERE table_name = 'Wait Services Checked'

IF @ldt_last_wait_check IS NULL OR @ldt_last_wait_check < DATEADD(minute, -1, @ldt_current_datetime)
	BEGIN
	-- Determine how many outstanding WAIT services should generate a warning
	SET @ls_temp = dbo.fn_get_global_preference('SERVERCONFIG', 'WAIT Service Warning Count')
	IF ISNUMERIC(@ls_temp) = 1
		SET @ll_wait_count_warning = CAST(@ls_temp AS int)
	ELSE
		SET @ll_wait_count_warning = 1000

	-- Count the WAIT services
	SELECT @ll_wait_count = count(*)
	FROM @services
	WHERE ordered_service = 'WAIT'

	IF @ll_wait_count >= @ll_wait_count_warning
		BEGIN
		SET @ls_temp = 'There are currently ' + CAST(@ll_wait_count AS varchar(12)) + ' outstanding WAIT services'

		EXECUTE jmj_new_log_message
			@ps_severity = 'WARNING',
			@ps_caller = 'SQL',
			@ps_script = 'jmjsys_ready_services',
			@ps_message = @ls_temp,
			@ps_created_by = @ps_user_id
		END

	-- Check the WAIT services
	UPDATE @services
	SET ready = dbo.fn_is_wait_service_ready(patient_workplan_item_id, getdate())
	WHERE ordered_service = 'WAIT'

	-- Update the WAIT check time
	EXECUTE sp_table_update
		@ps_table_name = 'Wait Services Checked',
		@ps_updated_by = @ps_user_id
	END


-- Cancel services where the service has been locked for more than 1 hour
DECLARE lc_locked CURSOR LOCAL FAST_FORWARD FOR
	SELECT x.patient_workplan_item_id
	FROM @services x
		INNER JOIN o_User_Service_Lock l
		ON x.patient_workplan_item_id = l.patient_workplan_item_id
	WHERE x.begin_date < DATEADD(hour, -1, getdate())

OPEN lc_locked

FETCH lc_locked INTO @ll_patient_workplan_item_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	EXECUTE sp_set_workplan_item_progress
		@pl_patient_workplan_item_id = @ll_patient_workplan_item_id,
		@ps_user_id = '#SYSTEM',
		@ps_progress_type = 'Cancelled',
		@ps_created_by = '#SYSTEM'

	UPDATE @services
	SET ready = 0
	WHERE patient_workplan_item_id = @ll_patient_workplan_item_id
	
	FETCH lc_locked INTO @ll_patient_workplan_item_id
	END

CLOSE lc_locked
DEALLOCATE lc_locked

-- Turn off ready flag if the service is locked already
UPDATE x
SET ready = 0
FROM @services x
	INNER JOIN o_User_Service_Lock l
	ON x.patient_workplan_item_id = l.patient_workplan_item_id


-- Before returning, call the jmj_log_perflog to see if any db stats need to be logged
EXECUTE jmj_log_perflog @ps_user_id

SELECT patient_workplan_item_id ,
	item_type,
	ordered_service ,
	in_office_flag ,
	ordered_by ,
	description ,
	dispatch_date ,
	begin_date ,
	end_date ,
	status ,
	retries ,
	escalation_date ,
	expiration_date ,
	dispatch_minutes ,
	priority ,
	ready ,
	context_object,
	cpr_id,
	encounter_id,
	problem_id ,
	treatment_id ,
	attachment_id
FROM @services
WHERE ready = 1

GO
GRANT EXECUTE ON [jmjsys_ready_services] TO [cprsystem] AS [dbo]
GO
