
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[sp_observation_search]
Print 'Drop Procedure [dbo].[sp_observation_search]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[sp_observation_search]') AND [type]='P'))
DROP PROCEDURE [dbo].[sp_observation_search]
GO

-- Create Procedure [dbo].[sp_observation_search]
Print 'Create Procedure [dbo].[sp_observation_search]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE     PROCEDURE sp_observation_search
(	@ps_treatment_type varchar(24) = NULL,
	@ps_observation_category_id varchar(24) = NULL,
	@ps_top_20_user_id varchar(24) = NULL,
	@ps_description varchar(80) = NULL,
	@ps_procedure_id varchar(24) = NULL,
	@ps_collect_cpt_code varchar(24) = NULL,
	@ps_perform_cpt_code varchar(24) = NULL,
	@ps_in_context_flag char(1) = NULL,
	@ps_specialty_id varchar(24) = NULL,
	@ps_composite_flag char(1) = NULL,
	@ps_status varchar(12) = NULL,
	@ps_top_20_code varchar(64) = NULL
)
AS

DECLARE @ls_no_treatment_type_icon varchar(128),
	@ls_multiple_treatment_type_icon varchar(128),
	@ls_top_20_code varchar(40)

IF @ps_status IS NULL
	SET @ps_status = '%'

SET @ls_no_treatment_type_icon = dbo.fn_get_global_preference('PREFERENCES', 'no_treatment_type_icon')

SET @ls_multiple_treatment_type_icon = dbo.fn_get_global_preference('PREFERENCES', 'multiple_treatment_type_icon')

DECLARE @tmp_observation TABLE
(	 observation_id varchar(24) NOT NULL
	,icon varchar(128) NULL
	,sort_sequence int NULL
	,top_20_sequence int NULL
	,description VARCHAR (80)
	,in_context_flag CHAR (1)
	,collection_procedure_id VARCHAR (24)
	,perform_procedure_id VARCHAR (24)
	,composite_flag CHAR (1)
	,treatment_type VARCHAR (24)
	,treatment_type_oc VARCHAR (24)
	,observation_category_id VARCHAR (24)
	,collection_cpt_code VARCHAR (24)
	,perform_cpt_code VARCHAR (24)
)

IF @ps_top_20_user_id IS NULL
	BEGIN
	IF @ps_specialty_id IS NULL
		INSERT INTO @tmp_observation 
		(	 observation_id
			,icon
			,sort_sequence
			,description
			,in_context_flag
			,collection_procedure_id
			,perform_procedure_id
			,composite_flag
			,treatment_type
			,treatment_type_oc
			,observation_category_id
			,collection_cpt_code
			,perform_cpt_code
		)
		SELECT DISTINCT
			 o.observation_id
			,@ls_no_treatment_type_icon
			,0
			,ISNULL( o.description, '^^' )
			,ISNULL( o.in_context_flag, '^^' )
			,ISNULL( o.collection_procedure_id, '^^' )
			,ISNULL( o.perform_procedure_id, '^^' )
			,ISNULL( o.composite_flag, '^^' )
			,treatment_type = CASE tt.treatment_type
						WHEN @ps_treatment_type then @ps_treatment_type
						ELSE '^^'
					  END
			,treatment_type_oc = CASE oc.treatment_type
						WHEN @ps_treatment_type then @ps_treatment_type
						ELSE '^^'
					  END
			,observation_category_id =CASE oc.observation_category_id
							WHEN @ps_observation_category_id then @ps_observation_category_id
							ELSE '^^'
					  	   END
			,collection_cpt_code =	CASE cpc.cpt_code
							WHEN @ps_collect_cpt_code then @ps_collect_cpt_code
							ELSE '^^'
					  	END
			,perform_cpt_code =	CASE cpp.cpt_code
							WHEN @ps_perform_cpt_code then @ps_perform_cpt_code
							ELSE '^^'
					  	END
		FROM 	c_Observation o WITH (NOLOCK)
		LEFT OUTER JOIN c_observation_treatment_type tt WITH (NOLOCK)
		ON 	o. observation_id = tt.observation_id
		LEFT OUTER JOIN c_observation_observation_cat oc WITH (NOLOCK)
		ON	o.observation_id = oc.observation_id
		LEFT OUTER JOIN c_procedure cpc WITH (NOLOCK)
		ON 	o.collection_procedure_id = cpc.procedure_id
		LEFT OUTER JOIN c_procedure cpp WITH (NOLOCK)
		ON 	o.perform_procedure_id = cpp.procedure_id
		WHERE 	o.status = @ps_status
	ELSE
		INSERT INTO @tmp_observation
		(	observation_id
			,icon
			,sort_sequence
			,description
			,in_context_flag
			,collection_procedure_id
			,perform_procedure_id
			,composite_flag
			,treatment_type
			,treatment_type_oc
			,observation_category_id
			,collection_cpt_code
			,perform_cpt_code
		)
		SELECT DISTINCT
			 o.observation_id
			,@ls_no_treatment_type_icon
			,0
			,ISNULL( o.description, '^^' )
			,ISNULL( o.in_context_flag, '^^' )
			,ISNULL( o.collection_procedure_id, '^^' )
			,ISNULL( o.perform_procedure_id, '^^' )
			,ISNULL( o.composite_flag, '^^' )
			,treatment_type = CASE tt.treatment_type
						WHEN @ps_treatment_type then @ps_treatment_type
						ELSE '^^'
					  END
			,treatment_type_oc = CASE oc.treatment_type
						WHEN @ps_treatment_type then @ps_treatment_type
						ELSE '^^'
					  END
			,observation_category_id =CASE oc.observation_category_id
							WHEN @ps_observation_category_id then @ps_observation_category_id
							ELSE '^^'
					  	   END
			,collection_cpt_code =	CASE cpc.cpt_code
							WHEN @ps_collect_cpt_code then @ps_collect_cpt_code
							ELSE '^^'
					  	END
			,perform_cpt_code =	CASE cpp.cpt_code
							WHEN @ps_perform_cpt_code then @ps_perform_cpt_code
							ELSE '^^'
					  	END
		FROM 	 c_Observation o WITH (NOLOCK)
		INNER JOIN c_Common_Observation c WITH (NOLOCK)
		ON	o.observation_id = c.observation_id
		LEFT OUTER JOIN c_observation_treatment_type tt WITH (NOLOCK)
		ON 	o. observation_id = tt.observation_id
		LEFT OUTER JOIN c_observation_observation_cat oc WITH (NOLOCK)
		ON	o.observation_id = oc.observation_id
		LEFT OUTER JOIN c_procedure cpc WITH (NOLOCK)
		ON 	o.collection_procedure_id = cpc.procedure_id
		LEFT OUTER JOIN c_procedure cpp WITH (NOLOCK)
		ON 	o.perform_procedure_id = cpp.procedure_id
		WHERE	
		 	c.specialty_id = @ps_specialty_id
		AND 	o.status = @ps_status
	END
ELSE
BEGIN
	IF @ps_treatment_type IS NULL
		SET @ls_top_20_code = @ps_top_20_code
	ELSE
		SET @ls_top_20_code = 'TEST_' + @ps_treatment_type

	INSERT INTO @tmp_observation
	(	 observation_id
		,icon
		,sort_sequence
		,top_20_sequence
		,description
		,in_context_flag
		,collection_procedure_id
		,perform_procedure_id
		,composite_flag
		,treatment_type
		,treatment_type_oc
		,observation_category_id
		,collection_cpt_code
		,perform_cpt_code
	)
	SELECT DISTINCT
		 o.observation_id
		,@ls_no_treatment_type_icon
		,COALESCE(u.sort_sequence, u.top_20_sequence)
		,u.top_20_sequence
		,ISNULL( o.description, '^^' )
		,ISNULL( o.in_context_flag, '^^' )
		,ISNULL( o.collection_procedure_id, '^^' )
		,ISNULL( o.perform_procedure_id, '^^' )
		,ISNULL( o.composite_flag, '^^' )
		,treatment_type = CASE tt.treatment_type
					WHEN @ps_treatment_type then @ps_treatment_type
					ELSE '^^'
				  END
		,treatment_type_oc = CASE oc.treatment_type
					WHEN @ps_treatment_type then @ps_treatment_type
					ELSE '^^'
				  END
		,observation_category_id =CASE oc.observation_category_id
						WHEN @ps_observation_category_id then @ps_observation_category_id
						ELSE '^^'
				  	   END
		,collection_cpt_code =	CASE cpc.cpt_code
						WHEN @ps_collect_cpt_code then @ps_collect_cpt_code
						ELSE '^^'
				  	END
		,perform_cpt_code =	CASE cpp.cpt_code
						WHEN @ps_perform_cpt_code then @ps_perform_cpt_code
						ELSE '^^'
				  	END
	FROM 	 c_Observation o WITH (NOLOCK)
	INNER JOIN u_Top_20 u WITH (NOLOCK)
	ON 	u.item_id = o.observation_id
	LEFT OUTER JOIN c_observation_treatment_type tt WITH (NOLOCK)
	ON 	o. observation_id = tt.observation_id
	LEFT OUTER JOIN c_observation_observation_cat oc WITH (NOLOCK)
	ON	o.observation_id = oc.observation_id
	LEFT OUTER JOIN c_procedure cpc WITH (NOLOCK)
	ON 	o.collection_procedure_id = cpc.procedure_id
	LEFT OUTER JOIN c_procedure cpp WITH (NOLOCK)
	ON 	o.perform_procedure_id = cpp.procedure_id
	WHERE 	o.status = @ps_status
	AND 	u.user_id = @ps_top_20_user_id
	AND 	u.top_20_code = @ls_top_20_code
END


IF @ps_description IS NOT NULL AND @ps_description <> '%'
BEGIN
	DELETE FROM @tmp_observation
	WHERE	description NOT LIKE @ps_description
END

IF @ps_treatment_type IS NOT NULL AND @ps_top_20_user_id IS NULL
BEGIN
	IF @ps_observation_category_id IS NULL
	BEGIN
		DELETE FROM @tmp_observation
		WHERE	treatment_type <> @ps_treatment_type
	END
	ELSE
	BEGIN
		DELETE FROM @tmp_observation
		WHERE
				observation_category_id <> @ps_observation_category_id
			OR	treatment_type_oc <> @ps_treatment_type
	END
END

IF @ps_in_context_flag IS NOT NULL
BEGIN
	DELETE FROM @tmp_observation
	WHERE	in_context_flag <> @ps_in_context_flag
END

IF @ps_collect_cpt_code IS NOT NULL
BEGIN
	DELETE FROM @tmp_observation
	WHERE collection_cpt_code <> @ps_collect_cpt_code
END

IF @ps_procedure_id IS NOT NULL
BEGIN
	DELETE FROM @tmp_observation
	WHERE perform_procedure_id <> @ps_procedure_id
END

IF @ps_perform_cpt_code IS NOT NULL
BEGIN
	DELETE FROM @tmp_observation
	WHERE perform_cpt_code <> @ps_perform_cpt_code
END

IF @ps_composite_flag IS NOT NULL
BEGIN
	DELETE FROM @tmp_observation
	WHERE
		composite_flag <> @ps_composite_flag
END


-- Get a list of treatment_type icons with counts per observation_id
DECLARE @tmp_observation_types TABLE
(	 observation_id varchar(24)
	,icon VARCHAR (64)
	,type_count INT
)

INSERT INTO @tmp_observation_types
(	 observation_id
	,icon
	,type_count
)
SELECT
	 o.observation_id
	,min(t.icon)
	,count(*)
FROM @tmp_observation o
	JOIN c_Observation_Observation_Cat c WITH (NOLOCK) ON o.observation_id = c.observation_id
	JOIN c_Treatment_Type t WITH (NOLOCK) ON c.treatment_type = t.treatment_type
WHERE t.icon IS NOT NULL
GROUP BY o.observation_id

-- Update the icon.  Use the treatment_type icon when only one such icon is related to
-- the observation.  Otherwise use the multiple_treatment_type_icon preference retrieved earlier
UPDATE o
SET icon = CASE t.type_count WHEN 1 THEN t.icon ELSE @ls_multiple_treatment_type_icon END
FROM @tmp_observation o
INNER JOIN @tmp_observation_types t
ON	o.observation_id = t.observation_id

SELECT DISTINCT
	 o.observation_id
	,o.collection_location_domain
	,o.perform_location_domain
	,o.collection_procedure_id
	,o.perform_procedure_id
	,o.description
	,o.composite_flag
	,o.exclusive_flag
	,t.sort_sequence
	,t.top_20_sequence
	,o.status
	,o.in_context_flag
	,t.icon
	,selected_flag = 0
FROM	 @tmp_observation t
INNER JOIN c_Observation o WITH (NOLOCK)
ON	o.observation_id = t.observation_id

GO
GRANT EXECUTE
	ON [dbo].[sp_observation_search]
	TO [cprsystem]
GO

