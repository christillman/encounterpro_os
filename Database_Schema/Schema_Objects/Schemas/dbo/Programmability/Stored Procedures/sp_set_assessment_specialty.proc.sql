CREATE PROCEDURE sp_set_assessment_specialty
	(
	@ps_assessment_id varchar(24),
	@ps_specialty_id varchar(24),
	@ps_flag char(1) = 'Y'
	)
AS

IF @ps_flag = 'Y'
	BEGIN
	IF NOT EXISTS(SELECT specialty_id
			  FROM c_Common_Assessment
			  WHERE specialty_id = @ps_specialty_id
			  AND assessment_id = @ps_assessment_id)
		INSERT INTO c_Common_Assessment (
			specialty_id,
			assessment_id)
		VALUES (
			@ps_specialty_id,
			@ps_assessment_id)
	END
ELSE
	BEGIN
	DELETE FROM c_Common_Assessment
	WHERE specialty_id = @ps_specialty_id
	AND assessment_id = @ps_assessment_id
	END

