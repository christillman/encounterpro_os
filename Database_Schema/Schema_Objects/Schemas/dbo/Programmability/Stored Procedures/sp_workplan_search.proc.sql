CREATE PROCEDURE sp_workplan_search (
	@ps_workplan_type varchar(24),
	@ps_workplan_category_id varchar(24) = NULL,
	@ps_in_office_flag char(1) = NULL,
	@ps_treatment_type varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL )
AS

DECLARE @ls_top_20_code varchar(40)

IF @ps_status IS NULL
	SELECT @ps_status = 'OK'

IF @ps_in_office_flag IS NULL
	SELECT @ps_in_office_flag = '%'

IF @ps_description IS NULL
	SELECT @ps_description = '%'

IF @ps_workplan_category_id IS NULL
	SELECT @ps_workplan_category_id = '%'

IF @ps_treatment_type IS NULL
	SELECT @ps_treatment_type = '%'

IF @ps_specialty_id IS NULL
	SELECT a.workplan_id,
		a.workplan_type,
		a.treatment_type,
		a.description,
		a.in_office_flag,
		'b_icon18.bmp',
		selected_flag=0
	FROM c_Workplan a
	WHERE a.workplan_type = @ps_workplan_type
	AND a.description like @ps_description
	AND (a.treatment_type like @ps_treatment_type OR a.treatment_type is NULL OR a.treatment_type = '')
	AND a.in_office_flag like @ps_in_office_flag
	AND a.status = 'OK'
	ORDER BY a.description
ELSE
	SELECT a.workplan_id,
		a.workplan_type,
		a.treatment_type,
		a.description,
		a.in_office_flag,
		'b_icon18.bmp',
		selected_flag=0
	FROM c_Workplan a
	WHERE a.workplan_type = @ps_workplan_type
	AND a.description like @ps_description
	AND (a.treatment_type like @ps_treatment_type OR a.treatment_type is NULL OR a.treatment_type = '')
	AND a.in_office_flag like @ps_in_office_flag
	AND a.specialty_id = @ps_specialty_id
	AND a.status = 'OK'
	ORDER BY a.description

