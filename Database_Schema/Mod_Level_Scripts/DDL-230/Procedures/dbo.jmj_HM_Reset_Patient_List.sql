
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmj_HM_Reset_Patient_List]
Print 'Drop Procedure [dbo].[jmj_HM_Reset_Patient_List]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmj_HM_Reset_Patient_List]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmj_HM_Reset_Patient_List]
GO

-- Create Procedure [dbo].[jmj_HM_Reset_Patient_List]
Print 'Create Procedure [dbo].[jmj_HM_Reset_Patient_List]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE jmj_HM_Reset_Patient_List
(	@pl_maintenance_rule_id int
)
AS

DECLARE @properties TABLE (
	property varchar(64) NOT NULL,
	operation varchar(24) NOT NULL,
	value varchar(255) NULL )

DECLARE @ls_property varchar(64),
		@ls_operation varchar(24),
		@ls_value varchar(255),
		@ls_sql nvarchar(max),
		@ls_where nvarchar(max),
		@ldt_dob_lower datetime,
		@ldt_dob_upper datetime,
		@ldt_today datetime,
		@ll_age_from int,
		@ls_age_from_unit varchar(24),
		@ll_age_to int,
		@ls_age_to_unit varchar(24),
		@ls_assessment_id varchar(24),
		@ls_open_flag char(1),
		@ls_treatment_type varchar(24),
		@ls_treatment_key varchar(40),
		@ll_count int,
		@ls_alias varchar(6),
		@ls_sex char(1),
		@ls_race varchar(12),
		@ll_age_range_id int,
		@ll_filter_from_maintenance_rule_id int,
		@ldt_status_date datetime

-- Anything before 5am counts as yesterday
SET @ldt_status_date = dbo.fn_date_truncate(DATEADD(hour, -5, dbo.get_client_datetime()), 'DAY')

SELECT @ls_sex = sex,
		@ls_race = race,
		@ll_age_range_id = age_range_id,
		@ll_filter_from_maintenance_rule_id = filter_from_maintenance_rule_id
FROM c_Maintenance_Patient_Class
WHERE maintenance_rule_id = @pl_maintenance_rule_id

-- First reset the parent
IF @ll_filter_from_maintenance_rule_id > 0
	EXECUTE jmj_HM_Reset_Patient_List @pl_maintenance_rule_id = @ll_filter_from_maintenance_rule_id

IF @ls_sex IS NOT NULL
	INSERT INTO @properties (
		property,
		operation,
		value)
	VALUES (
		'sex',
		'=',
		@ls_sex)

IF @ls_race IS NOT NULL
	INSERT INTO @properties (
		property,
		operation,
		value)
	VALUES (
		'race',
		'=',
		@ls_race)

IF @ll_age_range_id IS NOT NULL
	INSERT INTO @properties (
		property,
		operation,
		value)
	VALUES (
		'age',
		'In Age Range',
		CAST(@ll_age_range_id AS varchar(12)))

DECLARE lc_properties CURSOR LOCAL FAST_FORWARD FOR
	SELECT property,
			operation,
			value
	FROM @properties
	WHERE value IS NOT NULL

OPEN lc_properties

SET @ls_where = ''

FETCH lc_properties INTO @ls_property, @ls_operation, @ls_value
WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @ls_operation IN ('=', '<', '<=', '<>', '>', '>=')
		BEGIN
		IF @ls_where <> ''
			SET @ls_where = @ls_where + ' AND '
		SET @ls_where = @ls_where + ' p.' + @ls_property + ' ' + @ls_operation + ' ''' + @ls_value + ''''
		END
	ELSE IF @ls_operation = 'In Age Range'
		BEGIN
		SET @ldt_today = dbo.fn_date_truncate(getdate(), 'Day')
		SELECT @ll_age_from = age_from,
				@ls_age_from_unit = age_from_unit,
				@ll_age_to = age_to,
				@ls_age_to_unit = age_to_unit
		FROM c_Age_Range
		WHERE age_range_id = CAST(@ls_value AS int)

		IF @ll_age_to IS NOT NULL AND @ls_age_to_unit IS NOT NULL
			BEGIN
			IF @ls_where <> ''
				SET @ls_where = @ls_where + ' AND '
			SET @ldt_dob_lower = dbo.fn_date_add_interval(@ldt_today, -@ll_age_to, @ls_age_to_unit)
			SET @ls_where = @ls_where + ' p.date_of_birth > ''' + CONVERT(varchar(10), @ldt_dob_lower, 101) + ''''
			END

		IF @ll_age_from IS NOT NULL AND @ls_age_from_unit IS NOT NULL
			BEGIN
			IF @ls_where <> ''
				SET @ls_where = @ls_where + ' AND '
			SET @ldt_dob_upper = dbo.fn_date_add_interval(@ldt_today, -@ll_age_from, @ls_age_from_unit)
			SET @ls_where = @ls_where + ' p.date_of_birth <= ''' + CONVERT(varchar(10), @ldt_dob_upper, 101) + ''''
			END
		END

	FETCH lc_properties INTO @ls_property, @ls_operation, @ls_value
	END

CLOSE lc_properties
DEALLOCATE lc_properties

SELECT @ll_count = count(*)
FROM c_Maintenance_Assessment
WHERE maintenance_rule_id = @pl_maintenance_rule_id

IF @ll_count > 0
	BEGIN
	IF LEN(@ls_where) > 0
		SET @ls_where = @ls_where + ' AND '

	SET @ls_where = @ls_where + ' EXISTS ( SELECT 1 FROM p_Assessment a'
	SET @ls_where = @ls_where + '						INNER JOIN c_Maintenance_Assessment ma '
	SET @ls_where = @ls_where + '						ON a.assessment_id = ma.assessment_id '
	SET @ls_where = @ls_where + '				WHERE a.cpr_id = p.cpr_id '
	SET @ls_where = @ls_where + '				AND a.current_flag = ''Y'' '
	SET @ls_where = @ls_where + '				AND ISNULL(a.assessment_status, ''OPEN'') <> ''CANCELLED'' '
	SET @ls_where = @ls_where + '				AND ma.maintenance_rule_id = ' + CAST(@pl_maintenance_rule_id AS varchar(12))
	SET @ls_where = @ls_where + '				AND (ma.assessment_current_flag = ''A'' '
	SET @ls_where = @ls_where + '					 OR ISNULL(a.assessment_status, ''OPEN'') = ''OPEN'') '
	SET @ls_where = @ls_where + '			) '
	END


SELECT @ll_count = count(*)
FROM c_Maintenance_treatment
WHERE maintenance_rule_id = @pl_maintenance_rule_id

IF @ll_count > 0
	BEGIN
	IF LEN(@ls_where) > 0
		SET @ls_where = @ls_where + ' AND '

	SET @ls_where = @ls_where + ' EXISTS ( SELECT 1 FROM p_treatment_item t'
	SET @ls_where = @ls_where + '						INNER JOIN c_Maintenance_treatment mt '
	SET @ls_where = @ls_where + '						ON t.treatment_type = mt.treatment_type '
	SET @ls_where = @ls_where + '						AND t.treatment_key = mt.treatment_key '
	SET @ls_where = @ls_where + '				WHERE t.cpr_id = p.cpr_id '
	SET @ls_where = @ls_where + '				AND ISNULL(t.treatment_status, ''OPEN'') <> ''CANCELLED'' '
	SET @ls_where = @ls_where + '				AND mt.maintenance_rule_id = ' + CAST(@pl_maintenance_rule_id AS varchar(12))
	SET @ls_where = @ls_where + '				AND (mt.open_flag = ''A'' '
	SET @ls_where = @ls_where + '					 OR ISNULL(t.treatment_status, ''OPEN'') = ''OPEN'') '
	SET @ls_where = @ls_where + '			) '
	END



DELETE m
FROM p_Maintenance_Class m
WHERE m.maintenance_rule_id = @pl_maintenance_rule_id
AND m.status_date = @ldt_status_date

UPDATE m
SET current_flag = 'N'
FROM p_Maintenance_Class m
WHERE m.maintenance_rule_id = @pl_maintenance_rule_id

SET @ls_sql = '
INSERT INTO p_Maintenance_Class (
	maintenance_rule_id,
	status_date,
	cpr_id,
	in_class_flag)
SELECT maintenance_rule_id = ' + CAST(@pl_maintenance_rule_id as varchar(12)) + ',
	''' + CONVERT(varchar(10), @ldt_status_date, 101) + ''',
	p.cpr_id,
	''Y''
FROM p_Patient p '

IF @ll_filter_from_maintenance_rule_id > 0
	BEGIN
	SET @ls_sql = @ls_sql + '
INNER JOIN p_Maintenance_Class m
ON p.cpr_id = m.cpr_id
AND m.status_date = ''' + CONVERT(varchar(10), @ldt_status_date, 101) + '''
AND m.maintenance_rule_id = ' + CAST(@ll_filter_from_maintenance_rule_id as varchar(12)) + '
AND m.in_class_flag = ''Y'' '
	END

IF LEN(@ls_where) > 0
	SET @ls_sql = @ls_sql + ' WHERE ' + @ls_where

EXECUTE (@ls_sql)


-------------------------------------------------------------------------------------------
-- Now that we have a list of the patients in this class, find out who is on protocol and
-- who is off protocol
-------------------------------------------------------------------------------------------

DECLARE @tmp_maint_procs_dn TABLE
(	 cpr_id varchar(12) not null,
	protocol_sequence int not null,
	last_begin_date  datetime NULL
)

-- Get the exact matching treatments
INSERT INTO @tmp_maint_procs_dn
(	 cpr_id,
	protocol_sequence,
	last_begin_date
)
SELECT t.cpr_id,
	p.protocol_sequence,
	max(t.begin_date)
FROM p_Maintenance_Class m
	INNER JOIN c_Maintenance_Protocol_Item p WITH (NOLOCK)
	ON m.maintenance_rule_id = p.maintenance_rule_id
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON t.cpr_id = m.cpr_id
	AND t.treatment_type = p.treatment_type
	AND t.treatment_key = p.treatment_key
WHERE	m.maintenance_rule_id = @pl_maintenance_rule_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY t.cpr_id, p.protocol_sequence

-- Get a list of all the procedure_id values that match the same cpt_code
-- as a protocol cpr_id
DECLARE @procs TABLE (
	protocol_sequence int NOT NULL,
	procedure_id varchar(24) NOT NULL)

INSERT INTO @procs (
	protocol_sequence,
	procedure_id )
SELECT DISTINCT p.protocol_sequence, p1.procedure_id
FROM c_Maintenance_Protocol_Item p WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt
	ON p.treatment_type = tt.treatment_type
	AND tt.component_id = 'TREAT_PROCEDURE'
	INNER JOIN c_Procedure p1
	ON p.treatment_key = p1.procedure_id
WHERE p.maintenance_rule_id = @pl_maintenance_rule_id
UNION
SELECT DISTINCT p.protocol_sequence, p2.procedure_id
FROM c_Maintenance_Protocol_Item p WITH (NOLOCK)
	INNER JOIN c_Treatment_Type tt
	ON p.treatment_type = tt.treatment_type
	AND tt.component_id = 'TREAT_PROCEDURE'
	INNER JOIN c_Procedure p1
	ON p.treatment_key = p1.procedure_id
	INNER JOIN c_Procedure p2
	ON p1.cpt_code = p2.cpt_code
	AND LEN(p1.cpt_code) >= 4
WHERE p.maintenance_rule_id = @pl_maintenance_rule_id


-- Then get a list of the latest closed Procedures with the same CPT_code 
-- as the Procedure associated with each rule


INSERT INTO @tmp_maint_procs_dn
(	 cpr_id,
	protocol_sequence,
	last_begin_date
)
SELECT t.cpr_id,
	p.protocol_sequence,
	max(t.begin_date)
FROM p_Maintenance_Class m
	CROSS JOIN @procs p
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON t.cpr_id = m.cpr_id
	AND t.treatment_key = p.procedure_id
	AND t.key_field = 'P'
WHERE	m.maintenance_rule_id = @pl_maintenance_rule_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY t.cpr_id, p.protocol_sequence


-- Then get a list of the latest closed Perform Procedures associated with each rule
-- where the protocol is a procedure but the treatment is an observation where
-- the perform procedure matches the protocol procedure
INSERT INTO @tmp_maint_procs_dn
(	 cpr_id,
	protocol_sequence,
	last_begin_date
)
SELECT t.cpr_id,
	p.protocol_sequence,
	max(t.begin_date)
FROM p_Maintenance_Class m
	CROSS JOIN @procs p
	INNER JOIN c_Observation o WITH (NOLOCK)
	ON o.perform_procedure_id = p.procedure_id
	INNER JOIN p_Treatment_Item t WITH (NOLOCK)
	ON t.cpr_id = m.cpr_id
	AND t.treatment_key = o.observation_id
	AND t.key_field = 'O'
WHERE	m.maintenance_rule_id = @pl_maintenance_rule_id
AND 	t.treatment_status = 'CLOSED'
GROUP BY t.cpr_id, p.protocol_sequence

UPDATE pmc
SET on_protocol_flag = 'Y'
FROM p_Maintenance_Class pmc
	INNER JOIN c_Maintenance_Protocol p
	ON pmc.maintenance_rule_id = p.maintenance_rule_id
	INNER JOIN @tmp_maint_procs_dn x
	ON pmc.cpr_id = x.cpr_id
	AND p.protocol_sequence = x.protocol_sequence
WHERE pmc.maintenance_rule_id = @pl_maintenance_rule_id
AND dbo.get_client_datetime() < CASE p.interval_unit
							WHEN 'YEAR' THEN dateadd(year, p.interval, x.last_begin_date)
							WHEN 'MONTH' THEN dateadd(month, p.interval, x.last_begin_date)
							WHEN 'DAY' THEN dateadd(day, p.interval, x.last_begin_date)
							END



UPDATE c_Maintenance_Rule
SET last_reset = dbo.get_client_datetime()
WHERE maintenance_rule_id = @pl_maintenance_rule_id

GO
GRANT EXECUTE
	ON [dbo].[jmj_HM_Reset_Patient_List]
	TO [cprsystem]
GO

