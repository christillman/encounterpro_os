CREATE FUNCTION fn_workplan_item_attribute (
	@pl_patient_workplan_item_id int,
	@ps_attribute varchar(64))

RETURNS @attribute TABLE (
	[patient_workplan_item_id] [int] NOT NULL ,
	[attribute_sequence] [int] NOT NULL ,
	[patient_workplan_id] [int] NOT NULL ,
	[cpr_id] [varchar] (12)  NULL ,
	[attribute] [varchar] (64)  NOT NULL ,
	[value] [varchar] (255)  NULL ,
	[message] [text]  NULL ,
	[created_by] [varchar] (24)  NOT NULL ,
	[created] [datetime] NULL )

AS
BEGIN

DECLARE @ll_attribute_sequence int

SELECT @ll_attribute_sequence = max(attribute_sequence)
FROM p_Patient_WP_Item_Attribute
WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
AND attribute = @ps_attribute

IF @ll_attribute_sequence IS NOT NULL
	INSERT INTO @attribute (
		[patient_workplan_item_id] ,
		[attribute_sequence] ,
		[patient_workplan_id] ,
		[cpr_id] ,
		[attribute] ,
		[value] ,
		[message] ,
		[created_by] ,
		[created] )
	SELECT [patient_workplan_item_id] ,
		[attribute_sequence] ,
		[patient_workplan_id] ,
		[cpr_id] ,
		[attribute] ,
		[value] ,
		[message] ,
		[created_by] ,
		[created] 
	FROM p_Patient_WP_Item_Attribute
	WHERE patient_workplan_item_id = @pl_patient_workplan_item_id
	AND attribute_sequence = @ll_attribute_sequence

RETURN
END

