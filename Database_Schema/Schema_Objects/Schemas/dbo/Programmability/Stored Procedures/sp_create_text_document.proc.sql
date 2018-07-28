CREATE PROCEDURE sp_create_text_document (
	@ps_title varchar(255),
	@pl_category int = NULL,
	@ps_document varchar(4000),
	@pl_material_id int OUTPUT )
AS
DECLARE @ptrval binary(16)
INSERT INTO c_Patient_Material (
	title,
	category,
	object,
	status)
VALUES (
	@ps_title,
	@pl_category,
	@ps_document,
	'OK')
SELECT @pl_material_id = @@IDENTITY

