CREATE PROCEDURE sp_procedure_search (
	@ps_procedure_type varchar(24) = NULL,
	@ps_procedure_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_cpt_code varchar(24) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_procedure_type IS NULL
	SET @ps_procedure_type = '%'

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_description IS NULL
	SET @ps_description = '%'

IF @ps_procedure_category_id = '%'
	SET @ps_procedure_category_id = NULL

IF @ps_cpt_code = '%'
	SET @ps_cpt_code = NULL

IF @ps_specialty_id IS NULL
	SELECT a.procedure_id,
		a.procedure_type,
		a.procedure_category_id,
		a.description,
		a.cpt_code,
		a.status,
		t.icon,
		selected_flag=0
	FROM c_Procedure a WITH (NOLOCK)
	INNER JOIN c_procedure_Type t WITH (NOLOCK)
		ON a.procedure_type = t.procedure_type
	WHERE a.procedure_type like @ps_procedure_type
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_procedure_category_id IS NULL OR a.procedure_category_id LIKE @ps_procedure_category_id)
	AND (@ps_cpt_code IS NULL OR a.cpt_code LIKE @ps_cpt_code)
ELSE
	SELECT a.procedure_id,
		a.procedure_type,
		a.procedure_category_id,
		a.description,
		a.cpt_code,
		a.status,
		t.icon,
		selected_flag=0
	FROM c_Procedure a WITH (NOLOCK)
	INNER JOIN c_Common_procedure c WITH (NOLOCK)
		ON a.procedure_id = c.procedure_id
	INNER JOIN c_procedure_Type t WITH (NOLOCK)
		ON a.procedure_type = t.procedure_type
	WHERE a.procedure_type like @ps_procedure_type
	AND c.specialty_id = @ps_specialty_id
	AND a.status like @ps_status
	AND a.description like @ps_description
	AND (@ps_procedure_category_id IS NULL OR a.procedure_category_id LIKE @ps_procedure_category_id)
	AND (@ps_cpt_code IS NULL OR a.cpt_code LIKE @ps_cpt_code)


