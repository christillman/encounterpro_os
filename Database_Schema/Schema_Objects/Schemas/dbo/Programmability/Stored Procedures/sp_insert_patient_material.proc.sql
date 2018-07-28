CREATE PROCEDURE dbo.sp_insert_patient_material
	(@ps_title  varchar(255),
	@pi_category_id integer,
	@pi_material_id int OUTPUT)
AS

	INSERT INTO dbo.c_patient_material
	(title,category)
	VALUES(@ps_title,@pi_category_id)

	SELECT @pi_material_id = @@IDENTITY


