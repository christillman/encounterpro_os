CREATE TRIGGER tr_p_Observation_Result_insert ON dbo.p_Observation_Result
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN


---------------------------------------------------------------------------------------
-- Begin logic brought over from p_Observation_Comment trigger
---------------------------------------------------------------------------------------

-- For now we don't allow single quote characters in the comment_title.  This will be
-- fixed in a future build of EncounterPRO, but in the mean time, substitute a backwards quote (`)
--UPDATE c
--SET comment_title = REPLACE(i.comment_title, '''', '`')
--FROM p_observation_comment c
--	INNER JOIN inserted i
--	ON i.cpr_id = c.cpr_id
--	AND i.observation_sequence = c.observation_sequence
--	AND i.observation_comment_id  = c.observation_comment_id
--WHERE CHARINDEX('''', i.comment_title) > 0

UPDATE c
SET result = REPLACE(i.result, '''', '`')
FROM p_Observation_Result c
	INNER JOIN inserted i
	ON i.cpr_id = c.cpr_id
	AND i.observation_sequence = c.observation_sequence
	AND i.location_result_sequence  = c.location_result_sequence
WHERE CHARINDEX('''', i.result) > 0
AND i.result_type IN ('Comment', 'Attachment')


-- Get the latest attachment text if applicable.  Wait for an update lock on
-- p_Attachment to prevent deadlock with other processes which insert into
-- p_Attachment prior to inserting into p_Observation_Comment
--UPDATE p_observation_comment
--SET comment = a.attachment_text
--FROM inserted, p_Attachment a (UPDLOCK)
--WHERE inserted.cpr_id = p_observation_comment.cpr_id
--AND inserted.observation_sequence = p_observation_comment.observation_sequence
--AND inserted.observation_comment_id  = p_observation_comment.observation_comment_id
--AND inserted.attachment_id = a.attachment_id
--AND a.attachment_text IS NOT NULL

UPDATE c
SET long_result_value = a.attachment_text
FROM p_observation_result c
	INNER JOIN inserted i
	ON i.cpr_id = c.cpr_id
	AND i.observation_sequence = c.observation_sequence
	AND i.location_result_sequence  = c.location_result_sequence
	INNER JOIN p_Attachment a (UPDLOCK)
	ON i.attachment_id = a.attachment_id
WHERE c.long_result_value IS NULL
AND a.attachment_text IS NOT NULL

-- For current_flag, merged logic from p_Observation_Comment trigger
UPDATE t1
SET current_flag = 'N'
FROM p_Observation_Result t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.observation_sequence = t2.observation_sequence
	AND t1.location = t2.location
	AND t1.result_type = t2.result_type
	AND t1.result = t2.result
WHERE t1.location_result_sequence < t2.location_result_sequence
OR t1.result_date_time IS NULL
OR (t1.result_value IS NULL AND t1.long_result_value IS NULL AND t1.attachment_id IS NULL AND t1.result_type IN ('Comment', 'Attachment'))

-- Set the link in p_Attachment to here
--IF (SELECT sum(attachment_id) FROM inserted) > 0
--	UPDATE a
--	SET context_object = 'Observation',
--		object_key = i.observation_sequence
--	FROM p_Attachment a
--		INNER JOIN inserted i
--		ON a.cpr_id = i.cpr_id
--		AND a.attachment_id = i.attachment_id
--	WHERE i.attachment_id > 0
IF (SELECT sum(attachment_id) FROM inserted) > 0
	UPDATE a
	SET context_object = 'Observation',
		object_key = i.observation_sequence
	FROM p_Attachment a
		INNER JOIN inserted i
		ON a.cpr_id = i.cpr_id
		AND a.attachment_id = i.attachment_id
	WHERE i.attachment_id > 0


-- If the comment is dated right now and the treatment or the encounter is closed, then
-- back date the comment to the treatment begin date or the encounter date, whichever is later
DECLARE @commentdates TABLE (
	cpr_id varchar(12) NOT NULL,
	observation_sequence int NOT NULL,
	location_result_sequence int NOT NULL,
	result_date_time datetime NOT NULL,
	encounter_id int NULL,	
	treatment_id int NULL)

-- Get the candidates as those whose comment_date_time is right now
INSERT INTO @commentdates (
	cpr_id ,
	observation_sequence ,
	location_result_sequence ,
	result_date_time ,
	encounter_id ,
	treatment_id )
SELECT cpr_id ,
	observation_sequence ,
	location_result_sequence ,
	result_date_time ,
	encounter_id ,
	treatment_id
FROM inserted
WHERE current_flag = 'Y'
AND result_date_time >= DATEADD(second, -3, getdate())

-- Remove the candidates whose encounter is today and open
DELETE x
FROM @commentdates x
	INNER JOIN p_Patient_Encounter e
	ON x.cpr_id = e.cpr_id
	AND x.encounter_id = e.encounter_id
	INNER JOIN p_Treatment_Item t
	ON x.cpr_id = t.cpr_id
	AND x.treatment_id = t.treatment_id
WHERE e.encounter_status = 'OPEN'
AND dbo.fn_date_truncate(e.encounter_date, 'DAY') = dbo.fn_date_truncate(getdate(), 'DAY')
AND ISNULL(t.treatment_status, 'OPEN') = 'OPEN'

-- Update the remaining comment_date_time values to the greater of the treatment
-- begin_date or the encounter_date
UPDATE x
SET result_date_time = CASE WHEN e.encounter_date > t.begin_date THEN e.encounter_date ELSE t.begin_date END
FROM @commentdates x
	INNER JOIN p_Treatment_Item t
	ON x.cpr_id = t.cpr_id
	AND x.treatment_id = t.treatment_id
	INNER JOIN p_Patient_Encounter e
	ON x.cpr_id = e.cpr_id
	AND x.encounter_id = e.encounter_id

-- Finally, update the comment dates
UPDATE r
SET result_date_time = x.result_date_time
FROM p_Observation_Result r
	INNER JOIN @commentdates x
	ON r.cpr_id = x.cpr_id
	AND r.observation_sequence = x.observation_sequence
	AND r.location_result_sequence = x.location_result_sequence

---------------------------------------------------------------------------------------
-- End of logic brought over from p_Observation_Comment trigger
---------------------------------------------------------------------------------------



-- Initialize any null root_observation_sequence values to the observation_sequence
DECLARE @ll_result_count int

UPDATE r
SET root_observation_sequence = r.observation_sequence
FROM p_Observation_Result r
	INNER JOIN inserted i
	ON r.cpr_id = i.cpr_id
	AND r.observation_sequence = i.observation_sequence
	AND r.location_result_sequence = i.location_result_sequence
WHERE r.root_observation_sequence IS NULL

SET @ll_result_count = @@ROWCOUNT

-- If there were any null root_observation_sequence values, update them the their parent
-- whereever they points to a non-root
WHILE @ll_result_count > 0
BEGIN
	UPDATE r
	SET root_observation_sequence = o.parent_observation_sequence
	FROM p_Observation_Result r
		INNER JOIN inserted i
		ON r.cpr_id = i.cpr_id
		AND r.observation_sequence = i.observation_sequence
		AND r.location_result_sequence = i.location_result_sequence
		INNER JOIN p_Observation o
		ON r.cpr_id = o.cpr_id
		AND r.root_observation_sequence = o.observation_sequence
	WHERE o.parent_observation_sequence IS NOT NULL
	
	SET @ll_result_count = @@ROWCOUNT
END

DECLARE @ls_cpr_id varchar(12), 
		@ll_treatment_id int, 
		@ll_encounter_id int,
		@ls_created_by varchar(24),
		@ls_observed_by varchar(24),
		@ll_observation_sequence int,
		@ll_location_result_sequence int,
		@ls_observation_id varchar(24),
		@li_result_sequence smallint,
		@ls_sex char(1),
		@ldt_date_of_birth datetime,
		@ldt_current_date datetime,
		@ls_result_value varchar(40),
		@ls_result_unit varchar(12),
		@ls_abnormal_flag char(1),
		@ls_abnormal_nature varchar(8),
		@li_severity smallint,
		@ls_normal_range varchar(40),
		@ls_ordered_by varchar(24),
		@ll_workplan_id int,
		@ll_count int,
		@ll_patient_workplan_id int,
		@ls_description varchar(80)

DECLARE lc_bill_treatment_observation CURSOR LOCAL FAST_FORWARD FOR
	SELECT DISTINCT i.cpr_id, 
					i.treatment_id,
					i.encounter_id,
					i.created_by
	FROM inserted i
		INNER JOIN p_Treatment_Item t
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
		INNER JOIN p_Patient_Encounter e
		ON t.cpr_id = e.cpr_id
		AND t.open_encounter_id = e.encounter_id
	WHERE ISNULL(t.treatment_status, 'OPEN') = 'OPEN'
	AND (t.bill_children_collect = 1 OR t.bill_children_perform = 1)
	AND e.encounter_status = 'OPEN'

OPEN lc_bill_treatment_observation

FETCH lc_bill_treatment_observation INTO @ls_cpr_id , 
						@ll_treatment_id ,
						@ll_encounter_id ,
						@ls_created_by

WHILE @@FETCH_STATUS = 0
	BEGIN

	EXECUTE jmj_set_treatment_observation_billing
			@ps_cpr_id = @ls_cpr_id,
			@pl_encounter_id = @ll_encounter_id,
			@pl_treatment_id = @ll_treatment_id,
			@ps_created_by = @ls_created_by

	FETCH lc_bill_treatment_observation INTO @ls_cpr_id , 
							@ll_treatment_id ,
							@ll_encounter_id ,
							@ls_created_by
	END

CLOSE lc_bill_treatment_observation
DEALLOCATE lc_bill_treatment_observation
	


-- Now set the abnormal fields from the c_Observation_Result_Range table
SET @ldt_current_date = getdate()

DECLARE lc_results CURSOR LOCAL FAST_FORWARD FOR
	SELECT i.cpr_id,
			i.observation_sequence,
			i.location_result_sequence,
			i.observation_id ,
			i.result_sequence ,
			p.sex,
			p.date_of_birth ,
			i.result_value ,
			i.result_unit ,
			i.encounter_id ,
			i.treatment_id ,
			COALESCE(i.observed_by, i.created_by) as observed_by ,
			i.created_by ,
			t.ordered_by ,
			o.description
	FROM inserted i
		INNER JOIN p_Observation o
		ON i.cpr_id = o.cpr_id
		AND i.observation_sequence = o.observation_sequence
		INNER JOIN p_Patient p
		ON i.cpr_id = p.cpr_id
		LEFT OUTER JOIN p_Treatment_Item t
		ON i.cpr_id = t.cpr_id
		AND i.treatment_id = t.treatment_id
	WHERE i.result_value IS NOT NULL
	AND i.result_unit IS NOT NULL

OPEN lc_results

FETCH lc_results INTO @ls_cpr_id,
						@ll_observation_sequence,
						@ll_location_result_sequence,
						@ls_observation_id ,
						@li_result_sequence ,
						@ls_sex ,
						@ldt_date_of_birth ,
						@ls_result_value ,
						@ls_result_unit ,
						@ll_encounter_id ,
						@ll_treatment_id ,
						@ls_observed_by ,
						@ls_created_by ,
						@ls_ordered_by ,
						@ls_description

WHILE @@FETCH_STATUS = 0
	BEGIN
	SELECT @ls_abnormal_flag = abnormal_flag,
			@ls_abnormal_nature = abnormal_nature,
			@li_severity = severity,
			@ls_normal_range = normal_range,
			@ll_workplan_id = workplan_id
	FROM dbo.fn_observation_result_range(@ls_cpr_id,
										@ls_ordered_by,
										@ls_observation_id,
										@li_result_sequence,
										@ls_sex,
										@ldt_date_of_birth,
										@ls_result_value,
										@ls_result_unit,
										@ldt_current_date)

	IF @ls_abnormal_flag IS NOT NULL
		BEGIN
		UPDATE r
		SET abnormal_flag = @ls_abnormal_flag,
			abnormal_nature = @ls_abnormal_nature,
			severity = @li_severity,
			normal_range = @ls_normal_range
		FROM p_Observation_Result r
		WHERE cpr_id = @ls_cpr_id
		AND observation_sequence = @ll_observation_sequence
		AND location_result_sequence = @ll_location_result_sequence
		
		IF @ll_workplan_id IS NOT NULL
			BEGIN
			SELECT @ll_count = count(*)
			FROM p_Patient_WP
			WHERE cpr_id = @ls_cpr_id
			AND treatment_id = @ll_treatment_id
			AND workplan_id = @ll_workplan_id
			AND status = 'Current'
			
			IF @ll_count = 0
				BEGIN
				SET @ls_description = 'Abnormal result for ' + @ls_description
				
				EXECUTE sp_order_workplan
					@ps_cpr_id = @ls_cpr_id ,
					@pl_workplan_id = @ll_workplan_id ,
					@pl_encounter_id = @ll_encounter_id ,
					@pl_treatment_id = @ll_treatment_id ,
					@pl_observation_sequence = @ll_observation_sequence ,
					@ps_description = @ls_description ,
					@ps_ordered_by = @ls_observed_by ,
					@ps_created_by = @ls_created_by ,
					@pl_patient_workplan_id = @ll_patient_workplan_id OUTPUT
				END	
			END
		END
	
	FETCH lc_results INTO @ls_cpr_id,
							@ll_observation_sequence,
							@ll_location_result_sequence,
							@ls_observation_id ,
							@li_result_sequence ,
							@ls_sex ,
							@ldt_date_of_birth ,
							@ls_result_value ,
							@ls_result_unit ,
							@ll_encounter_id ,
							@ll_treatment_id ,
							@ls_observed_by ,
							@ls_created_by ,
							@ls_ordered_by ,
							@ls_description
	END

CLOSE lc_results
DEALLOCATE lc_results
	


-- Make sure the abnormal_flag and normal_range get set
UPDATE t1
SET abnormal_flag = COALESCE(t1.abnormal_flag, c.abnormal_flag),
	normal_range = COALESCE(t1.normal_range, c.normal_range)
FROM p_Observation_Result t1
	INNER JOIN inserted t2
	ON t1.cpr_id = t2.cpr_id
	AND t1.observation_sequence = t2.observation_sequence
	AND t1.location_result_sequence = t2.location_result_sequence
	INNER JOIN c_Observation_Result c
	ON t1.observation_id = c.observation_id
	AND t1.result_sequence = c.result_sequence

-- Now that the abnormal flags have been set for the result records, set the
-- 'Y' abnormal flags and the severity in the parent observation records
UPDATE o
SET abnormal_flag = CASE WHEN o.abnormal_flag = 'Y' OR x.max_abnormal_flag = 'Y' THEN 'Y' ELSE 'N' END,
	severity = CASE WHEN o.severity < x.max_severity THEN x.max_severity ELSE o.severity END
FROM p_Observation o
	INNER JOIN (
			SELECT r.cpr_id, 
					r.observation_sequence,
					max(r.abnormal_flag) as max_abnormal_flag,
					max(r.severity) as max_severity
			FROM p_Observation_Result r
			INNER JOIN inserted i
			ON r.cpr_id = i.cpr_id
			AND r.observation_sequence = i.observation_sequence
			AND r.location_result_sequence = i.location_result_sequence
			GROUP BY r.cpr_id, r.observation_sequence ) x
	ON o.cpr_id = x.cpr_id
	AND o.observation_sequence = x.observation_sequence


-- Update the Active Services table with the latest observation result for any
-- observation/result registered
UPDATE s
SET	result = r.result ,
	result_date_time = r.result_date_time ,
	location = r.location ,
	result_value = r.result_value ,
	result_unit = r.result_unit ,
	abnormal_flag = r.abnormal_flag ,
	abnormal_nature = r.abnormal_nature ,
	severity = r.severity ,
	result_amount_flag = c.result_amount_flag ,
	print_result_flag = c.print_result_flag ,
	print_result_separator = c.print_result_separator ,
	unit_preference = c.unit_preference ,
	display_mask = c.display_mask ,
	location_description = l.description 
FROM o_Active_Services s
	INNER JOIN inserted i
	ON s.cpr_id = i.cpr_id
	AND s.observation_id = i.observation_id
	AND s.result_sequence = i.result_sequence
	INNER JOIN p_Observation_Result r
	ON i.cpr_id = r.cpr_id
	AND i.observation_sequence = r.observation_sequence
	AND i.location_result_sequence = r.location_result_sequence
	LEFT OUTER JOIN c_Observation_Result c
	ON i.observation_id = c.observation_id
	AND i.result_sequence = c.result_sequence
	LEFT OUTER JOIN c_location l
	ON i.location = l.location


-- If the result field is '' then set the current_flag to 'N'
UPDATE r
SET current_flag = 'N'
FROM p_Observation_Result r
	INNER JOIN inserted i
	ON r.cpr_id = i.cpr_id
	AND r.observation_sequence = i.observation_sequence
	AND r.location_result_sequence = i.location_result_sequence
WHERE i.result = ''
AND i.current_flag = 'Y'

-- If the result value is '' and the result unit is not 'NA' then set the current_flag to 'N'
UPDATE r
SET current_flag = 'N'
FROM p_Observation_Result r
	INNER JOIN inserted i
	ON r.cpr_id = i.cpr_id
	AND r.observation_sequence = i.observation_sequence
	AND r.location_result_sequence = i.location_result_sequence
WHERE i.result_value = ''
AND i.result_unit NOT IN ('NA', 'TEXT')
AND i.current_flag = 'Y'

-- Commented this section out because it is included in logic brought over from the p_Observation_Comment trigger
--
-- If the result is dated right now and the treatment or the encounter is closed, then
-- back date the result to the treatment begin date
--UPDATE r
--SET result_date_time = t.begin_date
--FROM p_Observation_Result r
--	INNER JOIN inserted i
--	ON r.cpr_id = i.cpr_id
--	AND r.observation_sequence = i.observation_sequence
--	AND r.location_result_sequence = i.location_result_sequence
--	INNER JOIN p_Treatment_Item t
--	ON t.cpr_id = i.cpr_id
--	AND t.treatment_id = i.treatment_id
--	INNER JOIN p_Patient_Encounter e
--	ON t.cpr_id = e.cpr_id
--	AND t.open_encounter_id = e.encounter_id
--WHERE r.current_flag = 'Y'
--AND r.result_date_time >= DATEADD(second, -2, getdate())
--AND (ISNULL(t.treatment_status, 'OPEN') <> 'OPEN'
--	OR e.encounter_status <> 'OPEN' )

