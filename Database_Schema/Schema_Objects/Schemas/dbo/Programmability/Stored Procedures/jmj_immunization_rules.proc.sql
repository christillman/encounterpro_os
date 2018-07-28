CREATE PROCEDURE jmj_immunization_rules (
	@ps_disease_group varchar(24) = NULL,
	@pl_disease_id int = NULL)

AS

DECLARE @ll_disease_id int

IF @pl_disease_id = 0
	BEGIN
	SELECT TOP 1 @ll_disease_id = disease_id
	FROM c_Disease_Group_Item
	WHERE disease_group = @ps_disease_group
	END
ELSE
	SET @ll_disease_id = @pl_disease_id


SELECT s.dose_schedule_sequence ,
	description = CASE @pl_disease_id WHEN 0 THEN i.disease_group ELSE d.description END,
	s.disease_id ,
	s.dose_number ,
	s.sort_sequence ,
	s.dose_text
FROM c_Immunization_Dose_Schedule s
	INNER JOIN c_Disease_Group_Item i
	ON s.disease_id = i.disease_id
	INNER JOIn c_Disease d
	ON s.disease_id = d.disease_id
WHERE s.disease_id = @ll_disease_id
AND i.disease_group = @ps_disease_group


