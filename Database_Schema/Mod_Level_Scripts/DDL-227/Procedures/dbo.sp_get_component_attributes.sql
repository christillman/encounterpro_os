
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_get_component_attributes]
Print 'Drop Procedure [dbo].[sp_get_component_attributes]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_get_component_attributes]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_get_component_attributes]
GO

-- Create Procedure [dbo].[sp_get_component_attributes]
Print 'Create Procedure [dbo].[sp_get_component_attributes]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_get_component_attributes (
	@ps_component_id varchar(24),
	@ps_office_id varchar(4),
	@pl_computer_id int )
AS

DECLARE @tmp_comp_attr TABLE
(	attribute_sequence int IDENTITY (1,1) NOT NULL,
	attribute varchar(64) NOT NULL,
	value varchar(max) NULL
)

INSERT INTO @tmp_comp_attr
(
	attribute,
	value 
)
SELECT a.attribute,
	a.value
FROM c_Component_Base_Attribute a
JOIN c_Component_Registry r ON r.component_type = a.component_type
WHERE r.component_id = @ps_component_id

INSERT INTO @tmp_comp_attr
(	attribute,
	value 
)
SELECT attribute,
	value
FROM c_Component_Attribute
WHERE component_id = @ps_component_id

INSERT INTO @tmp_comp_attr
(	attribute,
	value 
)
SELECT attribute,
	value
FROM o_Component_Computer_Attribute
WHERE component_id = @ps_component_id
AND computer_id = @pl_computer_id

SELECT attribute_sequence,
	attribute,
	value
FROM @tmp_comp_attr


GO
GRANT EXECUTE
	ON [dbo].[sp_get_component_attributes]
	TO [cprsystem]
GO

