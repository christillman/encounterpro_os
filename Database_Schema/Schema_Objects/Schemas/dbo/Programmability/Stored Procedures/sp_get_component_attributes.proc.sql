CREATE PROCEDURE sp_get_component_attributes (
	@ps_component_id varchar(24),
	@ps_office_id varchar(4),
	@pl_computer_id int )
AS

DECLARE @tmp_comp_attr TABLE
(	attribute_sequence int IDENTITY (1,1) NOT NULL,
	attribute varchar(64) NOT NULL,
	value text NULL
)

INSERT INTO @tmp_comp_attr
(
	attribute,
	value 
)
SELECT a.attribute,
	a.value
FROM c_Component_Base_Attribute a, c_Component_Registry r
WHERE r.component_id = @ps_component_id
AND r.component_type = a.component_type

INSERT INTO @tmp_comp_attr
(	attribute,
	value
)
SELECT a.attribute,
	a.value
FROM o_Component_Base_Attribute a, c_Component_Registry r
WHERE r.component_id = @ps_component_id
AND r.component_type = a.component_type
AND a.office_id = @ps_office_id

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
FROM o_Component_Attribute
WHERE component_id = @ps_component_id
AND office_id = @ps_office_id

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


