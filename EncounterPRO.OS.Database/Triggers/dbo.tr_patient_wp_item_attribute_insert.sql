
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Trigger [dbo].[tr_patient_wp_item_attribute_insert]
Print 'Drop Trigger [dbo].[tr_patient_wp_item_attribute_insert]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[tr_patient_wp_item_attribute_insert]') AND [type]='TR'))
DROP TRIGGER [dbo].[tr_patient_wp_item_attribute_insert]
GO

-- Create Trigger [dbo].[tr_patient_wp_item_attribute_insert]
Print 'Create Trigger [dbo].[tr_patient_wp_item_attribute_insert]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER tr_patient_wp_item_attribute_insert ON p_Patient_WP_Item_attribute
FOR INSERT
AS

IF @@ROWCOUNT = 0
	RETURN


-- Update the parent workplan item encounter_id
IF EXISTS( 	SELECT 1 FROM inserted 
		WHERE attribute = 'message_object'
	 )
BEGIN
	INSERT INTO p_Patient_WP_Item_Attribute (
		patient_workplan_item_id,
		patient_workplan_id,
		cpr_id,
		attribute,
		value_short,
		actor_id,
		created_by,
		created)
	SELECT
		patient_workplan_item_id,
		patient_workplan_id,
		cpr_id,
		'context_object',
		value_short,
		actor_id,
		created_by,
		created
	FROM inserted
	WHERE attribute = 'message_object'
	AND patient_workplan_id > 0
	
	DELETE a
	FROM p_Patient_WP_Item_Attribute a
		INNER JOIN inserted i
		ON a.patient_workplan_item_id = i.patient_workplan_item_id
	WHERE i.attribute IN ('message_object', 'context_object')
	AND i.value_short <> 'General'
	AND i.patient_workplan_id = 0
END

UPDATE i
SET context_object = a.value_short
FROM p_Patient_WP_Item i
	INNER JOIN inserted a
	ON i.patient_workplan_item_id = a.patient_workplan_item_id
WHERE a.attribute IN ('context_object', 'message_object')
AND i.context_object IS NULL

-- Get the tokenized attributes into a temp table
-- In this context (p_Patient_WP_Item_Attribute and its driving table c_Workplan_Item_Attribute)
-- We only support "General" tokens that we can look up in the o_Preferences table
DECLARE @tokens TABLE (
	patient_workplan_item_id int NOT NULL,
	attribute_sequence int NOT NULL,
	attribute varchar(64) NOT NULL,
	value varchar(255) NOT NULL)

INSERT INTO @tokens (
	patient_workplan_item_id,
	attribute_sequence,
	attribute,
	[value])
SELECT i.patient_workplan_item_id,
	i.attribute_sequence,
	i.attribute,
	COALESCE(a.[value_short], CAST(a.[message] AS varchar(255)))
FROM inserted i
	INNER JOIN p_Patient_WP_Item_Attribute a
	ON i.patient_workplan_item_id = a.patient_workplan_item_id
	AND i.attribute_sequence = a.attribute_sequence
WHERE COALESCE(a.[value_short], CAST(a.[message] AS varchar(255))) IS NOT NULL
AND i.attribute IN ('treatment_id', 
						'encounter_id', 
						'problem_id', 
						'attachment_id', 
						'observation_tag', 
						'owner_flag', 
						'folder', 
						'message_subject',
						'description',
						'ordered_workplan_id',
						'forwarded_to_user_id',
						'observation_sequence')

IF @@ROWCOUNT > 0
	BEGIN
	-- If we're changing the description, make sure the previous description is recorded
	INSERT INTO p_Patient_WP_Item_Attribute (
		cpr_id,
		patient_workplan_id,
		patient_workplan_item_id,
		attribute,
		value_short,
		[message],
		actor_id,
		created_by)
	SELECT i.cpr_id,
		i.patient_workplan_id,
		i.patient_workplan_item_id,
		'original_description',
		CASE WHEN LEN(i.description) > 50 THEN NULL ELSE i.description END,
		CASE WHEN LEN(i.description) > 50 THEN i.description ELSE NULL END,
		u.actor_id,
		i.created_by
	FROM p_Patient_WP_Item i
		INNER JOIN @tokens t
		ON i.patient_workplan_item_id = t.patient_workplan_item_id
		INNER JOIN c_User u
		ON i.ordered_by = u.user_id
	WHERE t.attribute IN ('message_subject', 'description')
	AND NOT EXISTS (
		SELECT 1
		FROM p_Patient_WP_Item_Attribute a
		WHERE a.patient_workplan_item_id = t.patient_workplan_item_id
		AND a.attribute = 'original_description'
		AND a.attribute_sequence < t.attribute_sequence)


	-- Translate any tokenized attributes
	UPDATE @tokens
	SET	value = dbo.fn_get_preference('PROPERTY', SUBSTRING(value, 10, LEN(value) - 10), NULL, NULL)
	WHERE value LIKE '\%General %\%' ESCAPE '\'
		
	UPDATE wpi
	SET	 encounter_id = CASE t.attribute WHEN 'encounter_id' THEN CAST(t.value AS int) ELSE wpi.encounter_id END
		,treatment_id = CASE t.attribute WHEN 'treatment_id' THEN CAST(t.value AS int) ELSE wpi.treatment_id END
		,problem_id = CASE t.attribute WHEN 'problem_id' THEN CAST(t.value AS int) ELSE wpi.problem_id END
		,attachment_id = CASE t.attribute WHEN 'attachment_id' THEN CAST(t.value AS int) ELSE wpi.attachment_id END
		,observation_tag = CASE t.attribute WHEN 'observation_tag' THEN t.value ELSE wpi.observation_tag END
		,owner_flag = CASE t.attribute WHEN 'owner_flag' THEN t.value ELSE wpi.owner_flag END
		,folder = CASE t.attribute WHEN 'folder' THEN t.value ELSE wpi.folder END
		,description = CASE t.attribute WHEN 'description' THEN CAST(t.value AS varchar(80)) ELSE wpi.description END
		,ordered_workplan_id = CASE t.attribute WHEN 'ordered_workplan_id' THEN CAST(t.value AS int) ELSE wpi.ordered_workplan_id END
		,owned_by = CASE t.attribute WHEN 'forwarded_to_user_id' THEN CAST(t.value AS varchar(24)) ELSE wpi.owned_by END
	FROM 	p_Patient_WP_Item wpi
		INNER JOIN @tokens t
		ON 	t.patient_workplan_item_id = wpi.patient_workplan_item_id

	-- We only want the 'message_subject' to update the wpitem description if it's a service.  That way the intra-office
	-- messaging will use the message subject as the service bar description
	UPDATE wpi
	SET	 description = CASE t.attribute WHEN 'message_subject' THEN CAST(t.value AS varchar(80)) ELSE wpi.description END
	FROM 	p_Patient_WP_Item wpi
		INNER JOIN @tokens t
		ON 	t.patient_workplan_item_id = wpi.patient_workplan_item_id
	WHERE wpi.item_type = 'Service'
	END

GO

