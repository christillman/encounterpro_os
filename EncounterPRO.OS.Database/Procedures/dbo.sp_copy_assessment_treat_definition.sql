
DROP PROCEDURE IF EXISTS sp_copy_assessment_treat_definition
GO
CREATE PROCEDURE sp_copy_assessment_treat_definition (
	-- same definitions as the columns we are inserting into
	-- notice variables need to be prefixed with @,
	@user_id_copy_to varchar(24),
	@user_id_copy_from varchar(24),
	@treatment_type varchar(24),
	@assessment_id varchar(24)
)
AS BEGIN

	INSERT INTO u_assessment_treat_definition 
	(assessment_id,treatment_type, treatment_description,[user_id])
	SELECT assessment_id,treatment_type, treatment_description,@user_id_copy_to
	FROM u_assessment_treat_definition
	WHERE [user_id]=@user_id_copy_from
	And treatment_type=@treatment_type
	and assessment_id=@assessment_id

	print + 'Inserted ' + convert(varchar(10), @@rowcount) + ' rows for <' + @assessment_id + '>'
END
GO
