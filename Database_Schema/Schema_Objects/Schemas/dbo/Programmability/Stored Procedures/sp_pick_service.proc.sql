CREATE PROCEDURE sp_pick_service (
	@ps_context_object varchar(24) = 'ALL')
AS

DECLARE @service_list char(1)

SELECT @service_list = 'N'

IF @ps_context_object IS NULL OR @ps_context_object = ''
	SELECT @ps_context_object = 'ALL'

IF @ps_context_object = 'GENERAL'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE general_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'PATIENT'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE patient_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'ENCOUNTER'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE encounter_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'TREATMENT'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE treatment_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'ASSESSMENT'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE assessment_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'OBSERVATION'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE observation_flag = 'Y'
	AND status = 'OK'
	ORDER BY description asc

	SELECT @service_list = 'Y'
END
IF @ps_context_object = 'ALL' OR @service_list = 'N'
BEGIN
	SELECT service,
	description,
	button,
	selected_flag = 0
	FROM o_Service
	WHERE status = 'OK'
	ORDER BY description asc
END

