
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Function [dbo].[fn_workplan_item_attribute]
Print 'Drop Function [dbo].[fn_workplan_item_attribute]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[fn_workplan_item_attribute]') AND ([type]='IF' OR [type]='FN' OR [type]='TF')))
DROP FUNCTION [dbo].[fn_workplan_item_attribute]
GO

-- Create Function [dbo].[fn_workplan_item_attribute]
Print 'Create Function [dbo].[fn_workplan_item_attribute]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.fn_workplan_item_attribute (
	@pl_patient_workplan_item_id int,
	@ps_attribute varchar(64))

RETURNS @attribute TABLE (
	[patient_workplan_item_id] [int] NOT NULL ,
	[attribute_sequence] [int] NOT NULL ,
	[patient_workplan_id] [int] NOT NULL ,
	[cpr_id] [varchar](12)  NULL ,
	[attribute] [varchar](64)  NOT NULL ,
	[value] [varchar](255)  NULL ,
	[message] [nvarchar](max)  NULL ,
	[created_by] [varchar](255)  NOT NULL ,
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

GO
GRANT SELECT ON [dbo].[fn_workplan_item_attribute] TO [cprsystem]
GO

