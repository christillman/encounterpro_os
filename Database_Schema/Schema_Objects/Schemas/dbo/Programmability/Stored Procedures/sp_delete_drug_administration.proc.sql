CREATE PROCEDURE sp_delete_drug_administration (
	@ps_drug_id varchar(24),
	@pi_administration_sequence smallint )
AS
DELETE FROM c_Drug_Administration
WHERE drug_id = @ps_drug_id
AND administration_sequence = @pi_administration_sequence

