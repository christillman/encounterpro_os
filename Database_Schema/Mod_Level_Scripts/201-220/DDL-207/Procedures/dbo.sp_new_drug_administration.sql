
Print 'Drop Procedure sp_new_drug_administration'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'sp_new_drug_administration') AND [type]='P'))
DROP PROCEDURE sp_new_drug_administration
GO

Print 'Create Procedure sp_new_drug_administration'
GO
CREATE PROCEDURE sp_new_drug_administration (
	@ps_drug_id varchar(24),
	@pi_administration_sequence smallint,
	@ps_administer_frequency varchar(12),
	@pr_administer_amount real,
	@ps_administer_unit varchar(12), 	@ps_mult_by_what varchar(12),
	@ps_calc_per varchar(12),
	@ps_description varchar(40),
	@ps_form_rxcui varchar(40) )
AS
INSERT INTO c_Drug_Administration (
	drug_id,
	administration_sequence,
	administer_frequency,
	administer_amount,
	administer_unit,
	mult_by_what,
	calc_per,
	description,
	form_rxcui )
VALUES (
	@ps_drug_id,
	@pi_administration_sequence,
	@ps_administer_frequency,
	@pr_administer_amount,
	@ps_administer_unit,
	@ps_mult_by_what,
	@ps_calc_per,
	@ps_description,
	@ps_form_rxcui )

GRANT EXECUTE
	ON [dbo].sp_new_drug_administration
	TO [cprsystem]
