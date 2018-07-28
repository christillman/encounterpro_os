CREATE TRIGGER tr_u_Ass_treat_def_delete ON dbo.u_Assessment_treat_definition
FOR DELETE
AS

IF @@ROWCOUNT = 0
	RETURN

DECLARE @ls_xml varchar(8000),
		@ll_definition_id int,
		@ls_message varchar(255)

DECLARE lc_deleted CURSOR LOCAL FAST_FORWARD FOR
	SELECT definition_id
	FROM deleted

OPEN lc_deleted

FETCH lc_deleted INTO @ll_definition_id

WHILE @@FETCH_STATUS = 0
	BEGIN
	SET @ls_xml = (	SELECT '<deleted'
						+ ' definition_id="' + CAST(definition_id AS varchar(12)) + '"'
						+ ' assessment_id="' + ISNULL(assessment_id, '') + '"'
						+ ' treatment_type="' + ISNULL(treatment_type, '') + '"'
						+ ' treatment_description="' + ISNULL(treatment_description, '') + '"'
						+ ' workplan_id="' + ISNULL(CAST(workplan_id AS varchar(24)), '') + '"'
						+ ' followup_workplan_id="' + ISNULL(CAST(followup_workplan_id AS varchar(24)), '') + '"'
						+ ' user_id="' + ISNULL(user_id, '') + '"'
						+ ' sort_sequence="' + ISNULL(CAST(sort_sequence AS varchar(24)), '') + '"'
						+ ' instructions="' + ISNULL(instructions, '') + '"'
						+ ' parent_definition_id="' + ISNULL(CAST(parent_definition_id AS varchar(24)), '') + '"'
						+ ' child_flag="' + ISNULL(child_flag, '') + '"'
						+ ' created="' + CAST(created AS varchar(24)) + '"'
						+ ' />'
					FROM deleted 
					WHERE definition_id = @ll_definition_id )

	SELECT @ls_message = CAST(ISNULL(icd_9_code, '') + ' : ' + a.description + ' - ' + d.treatment_description AS varchar(255))
	FROM deleted d
		INNER JOIN c_Assessment_Definition a
		ON d.assessment_id = a.assessment_id
	WHERE definition_id = @ll_definition_id

	EXECUTE jmj_new_log_message
		@ps_severity = 'WARNING',
		@ps_caller = 'u_Assessment_Treat_Definition',
		@ps_script = 'DELETE Trigger',
		@ps_message = @ls_message,
		@ps_log_data = @ls_xml

	FETCH lc_deleted INTO @ll_definition_id
	END

CLOSE lc_deleted
DEALLOCATE lc_deleted

-- Delete attributes
DELETE FROM u_Assessment_treat_def_attrib
FROM deleted
WHERE deleted.definition_id = u_Assessment_treat_def_attrib.definition_id

-- Delete the children
DELETE d
FROM u_Assessment_treat_definition d
	INNER JOIN deleted x
	ON d.parent_definition_id = x.definition_id

