CREATE PROCEDURE jmj_task_messages (
	@pl_patient_workplan_item_id integer)
AS

DECLARE @attributes TABLE (
	attribute_sequence int NOT NULL,
	attribute varchar(64) NULL,
	message TEXT NULL,
	value_short varchar(50) NULL,
	created datetime NOT NULL,
	created_by varchar(24) NOT NULL,
	actor_id int NULL)

DECLARE @messages TABLE (
	message_from_user_id varchar(24),
	message_date_time datetime NOT NULL,
	message_type varchar(24) NOT NULL DEFAULT ('Sent to'),
	message TEXT NULL,
	message_subject varchar(80) NULL,
	forwarded_to_user_id varchar(24) NULL)

DECLARE @ldt_dispatched datetime,
		@ls_ordered_by varchar(24),
		@ls_ordered_for varchar(24),
		@ls_task_description varchar(80),
		@ldt_dispatched_cutoff datetime ,
		@ldt_end_date datetime,
		@ls_completed_by varchar(24),
		@ll_attribute_sequence int

INSERT INTO @attributes (
	attribute_sequence ,
	attribute ,
	message ,
	value_short ,
	created ,
	created_by ,
	actor_id )
SELECT attribute_sequence ,
	attribute ,
	message ,
	value_short ,
	created ,
	created_by ,
	actor_id
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute IN ('original_description', 'message_subject', 'task_message', 'forwarded_to_user_id', 'message', 'disposition')
AND (message IS NOT NULL OR value_short IS NOT NULL)

SELECT @ldt_dispatched = dispatch_date,
		@ls_ordered_by = ordered_by,
		@ls_ordered_for = ordered_for,
		@ls_task_description = description,
		@ldt_end_date = end_date,
		@ls_completed_by = completed_by,
		@ldt_dispatched_cutoff = DATEADD(s, 2, dispatch_date)
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id

------------------------------------------------------------
-- Add the origin
------------------------------------------------------------
IF @pl_patient_workplan_item_id > 0
	INSERT INTO @messages (
		message_from_user_id,
		message_date_time,
		message_type)
	VALUES (
		@ls_ordered_by,
		@ldt_dispatched,
		'Ordered for')

UPDATE m
SET [message] = CASE WHEN a.value_short IS NULL THEN a.[message] ELSE a.value_short END
FROM @messages m
	CROSS JOIN @attributes a
WHERE a.attribute = 'task_message'
AND a.created <= @ldt_dispatched_cutoff

UPDATE m
SET [message] = CASE WHEN a.value_short IS NULL THEN a.[message] ELSE a.value_short END
FROM @messages m
	CROSS JOIN @attributes a
WHERE a.attribute = 'message'
AND m.message IS NULL

UPDATE m
SET message_subject = COALESCE(a.value_short, CAST(a.message AS varchar(80)))
FROM @messages m
	CROSS JOIN @attributes a
WHERE a.attribute = 'original_description'
AND a.created <= @ldt_dispatched_cutoff

UPDATE m
SET message_subject = COALESCE(a.value_short, CAST(a.message AS varchar(80)))
FROM @messages m
	CROSS JOIN @attributes a
WHERE a.attribute = 'message_subject'
AND a.created <= @ldt_dispatched_cutoff
AND m.message_subject IS NULL

UPDATE m
SET message_subject = @ls_task_description
FROM @messages m
WHERE m.message_date_time = @ldt_dispatched
AND m.message_subject IS NULL

UPDATE m
SET forwarded_to_user_id = @ls_ordered_for
FROM @messages m
WHERE m.message_date_time = @ldt_dispatched
AND m.forwarded_to_user_id IS NULL


------------------------------------------------------------
-- Add the rest of the message events
------------------------------------------------------------
INSERT INTO @messages (
	message_from_user_id,
	message_date_time)
SELECT DISTINCT u.user_id,
				a.created
FROM @attributes a
	INNER JOIN c_User u
	ON a.actor_id = u.actor_id
WHERE a.created > @ldt_dispatched_cutoff
AND attribute IN ('message_subject', 'task_message', 'forwarded_to_user_id')

UPDATE m
SET [message] = CASE WHEN a.value_short IS NULL THEN a.message ELSE a.value_short END
FROM @messages m
	INNER JOIN @attributes a
	ON m.message_date_time = a.created
AND a.attribute IN ('task_message', 'message')

UPDATE m
SET message_subject = COALESCE(a.value_short, CAST(a.message AS varchar(80)))
FROM @messages m
	INNER JOIN @attributes a
	ON m.message_date_time = a.created
AND a.attribute = 'message_subject'

UPDATE m
SET forwarded_to_user_id = CAST(a.value_short AS varchar(24))
FROM @messages m
	INNER JOIN @attributes a
	ON m.message_date_time = a.created
AND a.attribute = 'forwarded_to_user_id'



------------------------------------------------------------
-- Finally, add the closing
------------------------------------------------------------
IF @ldt_end_date IS NOT NULL
	INSERT INTO @messages (
		message_from_user_id,
		message_date_time,
		message_type)
	VALUES (
		@ls_completed_by,
		@ldt_end_date,
		'Closed by')

-- Set the message to the latest disposition
SELECT @ll_attribute_sequence = MAX(attribute_sequence)
FROM @attributes
WHERE attribute = 'disposition'

UPDATE m
SET [message] = CASE WHEN a.value_short IS NULL THEN a.[message] ELSE a.value_short END
FROM @messages m
	CROSS JOIN @attributes a
WHERE a.attribute_sequence = @ll_attribute_sequence
AND message_from_user_id = @ls_completed_by
AND message_date_time = @ldt_end_date
AND message_type = 'Closed by'





SELECT message_from_user_id,
	message_date_time ,
	message_type,
	message,
	message_subject,
	forwarded_to_user_id
FROM @messages
WHERE message IS NOT NULL
OR message_subject IS NOT NULL
OR forwarded_to_user_id IS NOT NULL

