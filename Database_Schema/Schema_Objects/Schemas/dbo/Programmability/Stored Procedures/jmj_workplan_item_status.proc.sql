CREATE PROCEDURE jmj_workplan_item_status (
	@pl_patient_workplan_id int )

AS

DECLARE @wpitems TABLE (
	[level] [int] NOT NULL ,
	[step_number] [smallint] NULL ,
	[patient_workplan_id] [int] NULL ,
	[child_patient_workplan_id] [int] NULL ,
	[patient_workplan_item_id] [int] NULL ,
	[item_type] [varchar] (12) NOT NULL ,
	[description] [varchar] (80) NULL ,
	[child_workplan_status] [varchar] (12) NULL ,
	[item_status] [varchar] (12) NULL ,
	[owned_by] [varchar] (24) NULL ,
	[minutes] [int] NULL ,
	[insert_sequence] [int] IDENTITY(1,1) NOT NULL ,
	[workplan_id] [int] NULL
	)

DECLARE @ll_count int,
		@ll_level int

-- Don't allow for workplan_id = 0
IF @pl_patient_workplan_id = 0 OR @pl_patient_workplan_id IS NULL
	RETURN

SET @ll_level = 0

INSERT INTO @wpitems (
	level,
	child_patient_workplan_id,
	item_type,
	description,
	child_workplan_status,
	workplan_id)
SELECT @ll_level,
		patient_workplan_id,
		'Root',
		description,
		status,
		workplan_id
FROM p_Patient_WP
WHERE patient_workplan_id = @pl_patient_workplan_id

SET @ll_Count = 1

WHILE @ll_count > 0
	BEGIN
	SET @ll_level = @ll_level + 1
	
	INSERT INTO @wpitems (
		level,
		step_number,
		patient_workplan_id,
		child_patient_workplan_id,
		patient_workplan_item_id,
		item_type,
		description,
		child_workplan_status,
		item_status,
		minutes,
		owned_by,
		workplan_id)
	SELECT @ll_level,
			i.step_number,
			i.patient_workplan_id,
			w.patient_workplan_id,
			i.patient_workplan_item_id,
			i.item_type,
			i.description,
			w.status,
			ISNULL(i.status, 'Pending'),
			DATEDIFF(minute, i.dispatch_date, getdate()) as minutes,
			i.owned_by,
			i.workplan_id
	FROM @wpitems t
		INNER JOIN p_Patient_WP_Item i
		ON t.child_patient_workplan_id = i.patient_workplan_id
		LEFT OUTER JOIN p_Patient_WP w
		ON i.patient_workplan_item_id = w.parent_patient_workplan_item_id
	WHERE t.level = @ll_level - 1
	AND ISNULL(i.status, 'Pending') NOT IN ('Skipped', 'Cancelled')
	AND (i.step_number > 0 OR t.workplan_id = 0) -- if it's a manual workplan then get all items
	ORDER BY i.patient_workplan_item_id
	
	SET @ll_count = @@ROWCOUNT

	END

-- Remove the parent records which have no children
DELETE t1
FROM @wpitems t1
WHERE t1.child_patient_workplan_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
	FROM @wpitems t2
	WHERE t1.child_patient_workplan_id = t2.patient_workplan_id
	AND t1.level = t2.level - 1 )

SELECT [level] ,
	[step_number] ,
	[patient_workplan_id] ,
	[child_patient_workplan_id] ,
	[patient_workplan_item_id] ,
	[item_type] ,
	[description] ,
	[child_workplan_status] ,
	[item_status] ,
	[owned_by] ,
	[minutes] ,
	[insert_sequence]  ,
	[workplan_id]
FROM @wpitems

