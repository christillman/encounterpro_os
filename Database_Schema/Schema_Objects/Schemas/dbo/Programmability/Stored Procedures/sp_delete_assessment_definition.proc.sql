CREATE PROCEDURE sp_delete_assessment_definition (
	@ps_assessment_id varchar(24) )
AS

UPDATE c_Assessment_Definition
SET status = 'NA'
WHERE assessment_id = @ps_assessment_id

DELETE FROM u_Top_20
WHERE item_id = @ps_assessment_id
AND top_20_code like 'ASS%'

