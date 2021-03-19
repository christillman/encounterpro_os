
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_drug_search]
Print 'Drop Procedure [dbo].[sp_drug_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_drug_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_drug_search]
GO

-- Create Procedure [dbo].[sp_drug_search]
Print 'Create Procedure [dbo].[sp_drug_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE sp_drug_search (
	@ps_drug_category_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_generic_name varchar(500) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_status varchar(12) = 'OK',
	@ps_drug_type varchar(24) = '%' )
AS

DECLARE @ls_drug_flag char(1)
DECLARE @ls_drug_type varchar(24)
DECLARE @ls_description varchar(80)

SET @ls_drug_flag = '%'

IF @ps_description IS NULL
	SET @ls_description = '%'
ELSE
	SET @ls_description = @ps_description

-- Check for the special drug type "Drug" which really means drug_flag='Y'

IF @ps_drug_type IS NULL
	SET @ls_drug_type = '%'
ELSE IF @ps_drug_type = 'Drug'
	BEGIN
	SET @ls_drug_type = '%'
	SET @ls_drug_flag = 'Y'
	END
ELSE
	SET @ls_drug_type = @ps_drug_type

SELECT drug_id,
	description,
	status,
	icon,
	selected_flag = 0
FROM v_drug_search
WHERE status = COALESCE(@ps_status,'OK')
	AND common_name like @ls_description
	AND COALESCE(generic_name, '') like COALESCE(@ps_generic_name,'%')
	 -- compare to @ps_specialty_id if not null
	AND COALESCE(specialty_id,'0') = COALESCE(@ps_specialty_id,specialty_id,'0')
	AND COALESCE(drug_category_id,'') like COALESCE(@ps_drug_category_id,'%')
	AND drug_type like @ls_drug_type	
	AND drug_flag like @ls_drug_flag
UNION
SELECT drug_id,
	description,
	status,
	icon,
	selected_flag = 0
FROM c_Synonym s
JOIN v_drug_search
	ON common_name like '%' + s.alternate + '%'
WHERE s.term_type = 'drug_ingredient'
	AND s.term like CASE WHEN @ls_description = '%' THEN 'zzz' ELSE @ls_description END
	AND status = COALESCE(@ps_status,'OK')
	AND COALESCE(specialty_id,'0') = COALESCE(@ps_specialty_id,specialty_id,'0')
	AND COALESCE(drug_category_id,'') like COALESCE(@ps_drug_category_id,'%')	
	AND drug_type like @ls_drug_type
	AND drug_flag like @ls_drug_flag
UNION
SELECT drug_id,
	description,
	status,
	icon,
	selected_flag = 0
FROM c_Synonym s
JOIN v_drug_search
	ON generic_name like '%' + s.alternate + '%'
WHERE s.term_type = 'drug_ingredient'
	AND s.term like CASE WHEN COALESCE(@ps_generic_name,'%') = '%' THEN 'zzz' ELSE COALESCE(@ps_generic_name,'%') END
	AND status = COALESCE(@ps_status,'OK')
	AND COALESCE(specialty_id,'0') = COALESCE(@ps_specialty_id,specialty_id,'0')
	AND COALESCE(drug_category_id,'') like COALESCE(@ps_drug_category_id,'%')
	AND drug_type like @ls_drug_type
	AND drug_flag like @ls_drug_flag
	
	 /* exec [sp_drug_search] NULL, NULL, '%Acetaminophen%', NULL, NULL, 'Drug' */
	 /* exec [sp_drug_search] NULL, NULL, '%Paracetamol%', NULL, NULL, 'Drug' */
	 /* exec [sp_drug_search] NULL, 'Ziak', NULL, NULL, NULL, 'Drug' */
	 /* exec [sp_drug_search] NULL, '%', NULL, NULL, NULL, 'Vaccine' */
GO
GRANT EXECUTE
	ON [dbo].[sp_drug_search]
	TO [cprsystem]
GO
