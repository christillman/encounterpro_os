CREATE PROCEDURE sp_drug_search (
	@ps_drug_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_generic_name varchar(40) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_drug_type varchar(24) = NULL )
AS

DECLARE @ls_drug_flag char(1)

SET @ls_drug_flag = '%'

IF @ps_status IS NULL
	SET @ps_status = 'OK'

IF @ps_description IS NULL
	SET @ps_description = '%'

IF @ps_generic_name IS NULL
	SET @ps_generic_name = '%'

IF @ps_drug_category_id IS NULL
	SET @ps_drug_category_id = '%'

-- Check for the special drug type "Drug" which really means drug_flag='Y'
-- For backward compatibility, also check for the special code '%Drug'
IF @ps_drug_type = 'Drug' OR @ps_drug_type LIKE '%Drug'
	BEGIN
	SET @ps_drug_type = '%'
	SET @ls_drug_flag = 'Y'
	END

IF @ps_drug_type IS NULL
	SET @ps_drug_type = '%'

IF @ps_specialty_id IS NULL
	IF @ps_drug_category_id = '%' -- drugs in all category plus null category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			LEFT OUTER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
	ELSE -- drugs in specific category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			INNER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
ELSE
	IF @ps_drug_category_id = '%' -- to includes drugs with no category with left outer join
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			LEFT OUTER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
			INNER JOIN c_Common_Drug cd
			ON a.drug_id = cd.drug_id
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND cd.specialty_id = @ps_specialty_id
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END
	ELSE -- drugs in specific category
	 BEGIN
		SELECT distinct a.drug_id,
			a.common_name + CASE WHEN a.common_name = ISNULL(a.generic_name, a.common_name) THEN '' ELSE ' (' + a.generic_name + ')' END as description ,
			a.status,
			COALESCE(t.button, 'b_new03.bmp') as icon,
			selected_flag=0
		FROM c_Drug_Definition a
			INNER JOIN c_Drug_Drug_Category c
			ON a.drug_id = c.drug_id
			INNER JOIN c_Drug_Type t
			ON a.drug_type = t.drug_type
			INNER JOIN c_Common_Drug cd
			ON a.drug_id = cd.drug_id
		WHERE a.status like @ps_status
		AND a.common_name like @ps_description
		AND ISNULL(a.generic_name, '') like @ps_generic_name
		AND cd.specialty_id = @ps_specialty_id
		AND isnull(c.drug_category_id, '') like @ps_drug_category_id	
		AND a.drug_type like @ps_drug_type
		AND t.drug_flag like @ls_drug_flag
	 END


