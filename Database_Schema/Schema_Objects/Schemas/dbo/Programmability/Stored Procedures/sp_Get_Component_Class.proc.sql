CREATE PROCEDURE sp_Get_Component_Class
	@ps_component_id varchar(24)
	--, @ps_component_class varchar(128) OUTPUT,
	--@ps_id char(36) OUTPUT
AS

DECLARE @ls_component_class varchar(128), @ls_id char(36)

-- SELECT @ps_component_class = component_class,
-- 	@ps_id = convert(char(36), id)
-- FROM c_Component_Registry
-- WHERE component_id = @ps_component_id

SELECT @ls_component_class = component_class,
	@ls_id = convert(char(36), id)
FROM c_Component_Registry
WHERE component_id = @ls_component_class

SELECT @ls_component_class AS component_class, @ls_id AS id


