
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_document_objects]
Print 'Drop Function [dbo].[fn_document_objects]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_document_objects]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_document_objects]
GO

-- Create Function [dbo].[fn_document_objects]
Print 'Create Function [dbo].[fn_document_objects]'
GO
SET ANSI_NULLS OFF
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION fn_document_objects (
	@pl_document_patient_workplan_item_id int
	)

RETURNS @objects TABLE (
	[object_sequence] [int] NOT NULL,
	[cpr_id] [varchar](12) NOT NULL,
	[context_object] [varchar] (24) NOT NULL,
	[object_key] [int] NOT NULL,
	[object_date] [datetime] NOT NULL,
	[object_type] [varchar] (24) NOT NULL ,
	[object_description] [varchar] (80) NOT NULL ,
	[object_status] [varchar] (12) NOT NULL ,
	[office_id] varchar(4) NULL ,
	[office_user_id] varchar(24) NULL ,
	[id] [uniqueidentifier] NOT NULL
	)

AS

BEGIN

DECLARE @ll_interfaceServiceId int,
		@ls_ordered_for varchar(24),
		@ll_error int,
		@ll_rowcount int

DECLARE @tempobjects TABLE (
	[object_sequence] [int] NOT NULL,
	[cpr_id] [varchar](12) NOT NULL,
	[context_object] [varchar] (24) NOT NULL,
	[object_key] [int] NOT NULL,
	[object_status] [varchar] (12) NOT NULL ,
	[id] [uniqueidentifier] NOT NULL
	)

SELECT @ls_ordered_for = ordered_for,
		@ll_interfaceServiceId = dbo.fn_document_interfaceserviceid(@pl_document_patient_workplan_item_id)
FROM p_Patient_WP_Item
WHERE patient_workplan_item_id = @pl_document_patient_workplan_item_id

SELECT @ll_error = @@ERROR,
		@ll_rowcount = @@ROWCOUNT

IF @ll_error <> 0
	RETURN

IF @ll_rowcount <> 1
	RETURN


-- Make sure that the logged objects are intended for the same interfaceserviceid that is associated with the document recipient
INSERT INTO @tempobjects (
	[object_sequence],
	[cpr_id],
	[context_object],
	[object_key],
	[object_status],
	[id])
SELECT [object_sequence],
	[cpr_id],
	[context_object],
	[object_key],
	[object_status],
	[id]
FROM dbo.c_component_interface_object_log
WHERE document_patient_workplan_item_id = @pl_document_patient_workplan_item_id
AND interfaceserviceid = @ll_interfaceServiceId


INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = ISNULL(p.created, '1/1/1900'),
	object_type = 'Patient',
	object_description = dbo.fn_pretty_name(last_name, first_name, middle_name, name_suffix, name_prefix, degree),
	x.object_status,
	p.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Patient p
	ON x.cpr_id = p.cpr_id
WHERE x.context_object = 'patient'

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = e.encounter_date,
	object_type = e.encounter_type,
	object_description = ISNULL(e.encounter_description, x.context_object + ' ' + CAST(x.object_key AS varchar(12))),
	x.object_status,
	e.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Patient_Encounter e
	ON x.cpr_id = e.cpr_id
	AND x.object_key = e.encounter_id
WHERE x.context_object = 'Encounter'
AND e.encounter_date IS NOT NULL
AND e.encounter_type IS NOT NULL
AND e.encounter_status <> 'Canceled'

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = a.begin_date,
	object_type = a.assessment_type,
	object_description = ISNULL(a.assessment, x.context_object + ' ' + CAST(x.object_key AS varchar(12))),
	x.object_status,
	e.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Assessment a
	ON x.cpr_id = a.cpr_id
	AND x.object_key = a.problem_id
	INNER JOIN p_Patient_Encounter e
	ON a.cpr_id = e.cpr_id
	AND a.open_encounter_id = e.encounter_id
WHERE x.context_object = 'Assessment'
AND a.begin_date IS NOT NULL
AND a.assessment_type IS NOT NULL
AND a.current_flag = 'Y'

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = t.begin_date,
	object_type = t.treatment_type,
	object_description = ISNULL(t.treatment_description, x.context_object + ' ' + CAST(x.object_key AS varchar(12))),
	x.object_status,
	t.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Treatment_Item t
	ON x.cpr_id = t.cpr_id
	AND x.object_key = t.treatment_id
WHERE x.context_object = 'Treatment'
AND t.begin_date IS NOT NULL
AND t.treatment_type IS NOT NULL
AND ISNULL(t.treatment_status, 'Open') <> 'Cancelled'

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = t.begin_date,
	object_type = t.treatment_type,
	object_description = ISNULL(o.description, x.context_object + ' ' + CAST(x.object_key AS varchar(12)))
								+ CASE WHEN o.observation_tag IS NULL THEN '' ELSE ' (' + o.observation_tag + ')' END,
	x.object_status,
	t.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Observation o
	ON x.cpr_id = o.cpr_id
	AND x.object_key = o.observation_sequence
	INNER JOIN p_Treatment_Item t
	ON o.cpr_id = t.cpr_id
	AND o.treatment_id = t.treatment_id
WHERE x.context_object = 'Observation'
AND t.begin_date IS NOT NULL
AND t.treatment_type IS NOT NULL
AND ISNULL(t.treatment_status, 'Open') <> 'Cancelled'

INSERT INTO @objects (
	object_sequence,
	cpr_id,
	context_object,
	object_key,
	object_date,
	object_type,
	object_description,
	object_status,
	office_id,
	id)
SELECT x.object_sequence,
	x.cpr_id,
	x.context_object,
	x.object_key,
	object_date = COALESCE(a.attachment_date, a.created, '1/1/1900'),
	object_type = ISNULL(a.attachment_type, 'File'),
	object_description = ISNULL(a.attachment_tag, x.context_object + ' ' + CAST(x.object_key AS varchar(12))),
	x.object_status,
	e.office_id,
	x.id
FROM @tempobjects x
	INNER JOIN p_Attachment a
	ON x.cpr_id = a.cpr_id
	AND x.object_key = a.attachment_id
	INNER JOIN p_Patient_Encounter e
	ON a.cpr_id = e.cpr_id
	AND a.encounter_id = e.encounter_id
WHERE x.context_object = 'Attachment'
AND a.status = 'OK'

DECLARE @ls_primary_office_user_id varchar(24),
		@ls_primary_office_id varchar(4)

SELECT @ls_primary_office_user_id = min(u.user_id)
FROM c_User u
	INNER JOIN c_Office o
	ON u.office_id = o.office_id
WHERE u.actor_class = 'Office'

SELECT @ls_primary_office_id = u.office_id
FROM c_User u
WHERE user_id = @ls_primary_office_user_id

DECLARE @offices TABLE (
	office_id varchar(4) NOT NULL,
	office_user_id varchar(24) NOT NULL)

INSERT INTO @offices (
	office_id ,
	office_user_id)
SELECT office_id,
		dbo.fn_office_user_id(office_id)
FROM c_Office

UPDATE x
SET office_id = @ls_primary_office_id
FROM @objects x
WHERE office_id IS NULL

UPDATE x
SET office_user_id = o.office_user_id
FROM @objects x
	INNER JOIN @offices o
	ON x.office_id = o.office_id

RETURN

END

GO
GRANT SELECT ON [dbo].[fn_document_objects] TO [cprsystem]
GO

