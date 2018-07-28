CREATE PROCEDURE jmj_check_age_range_procedure (
	@ps_list_id varchar(24) )
AS

DECLARE @ls_age_range_category varchar(24),
	@li_count smallint

SELECT @li_count = COUNT(DISTINCT a.age_range_category),
	@ls_age_range_category = min(a.age_range_category)
FROM c_Age_Range a
	INNER JOIN c_Age_Range_Procedure p
	ON a.age_range_id = p.age_range_id

IF @li_count = 0
	SET @ls_age_range_category = 'Stages'
ELSE IF @li_count > 1
	BEGIN
	RAISERROR ('This list id has multiple stages assigned (%s)',16,-1, @ps_list_id)
	ROLLBACK TRANSACTION
	RETURN
	END

INSERT INTO c_Age_Range_Procedure (
	list_id,
	age_range_id,
	procedure_id)
SELECT @ps_list_id,
	age_range_id,
	'< No Procedure >'
FROM c_Age_Range
WHERE age_range_category = @ls_age_range_category
AND age_range_id NOT IN (
	SELECT age_range_id
	FROM c_Age_Range_Procedure
	WHERE list_id = @ps_list_id)


SELECT list_id,
	age_range_id,
	procedure_id
FROM c_Age_Range_Procedure p
WHERE list_id = @ps_list_id
AND NOT EXISTS (
	SELECT procedure_id
	FROM c_Procedure c
	WHERE c.procedure_id = p.procedure_id )


