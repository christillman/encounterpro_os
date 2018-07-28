CREATE PROCEDURE jmj_add_patient_relation (
	@ps_cpr_id varchar(12),
	@ps_relation_cpr_id varchar(12),
	@ps_relationship varchar(24) ,
	@ps_created_by varchar(24) )
AS

DECLARE	@ls_maternal_sibling_flag char(1) ,
		@ls_paternal_sibling_flag char(1) ,
		@ls_parent_flag char(1) ,
		@ls_guardian_flag char(1) ,
		@ls_guarantor_flag char(1) ,
		@ls_payor_flag char(1) ,
		@ls_primary_decision_maker_flag char(1) 


SET	@ls_maternal_sibling_flag = 'N'
SET	@ls_paternal_sibling_flag = 'N'
SET	@ls_parent_flag = 'N'
SET	@ls_guardian_flag = 'N'
SET	@ls_guarantor_flag = 'N'
SET	@ls_payor_flag = 'N'
SET	@ls_primary_decision_maker_flag = 'N'

IF @ps_relationship IN ('sibling', 'maternal sibling', 'maternal half sibling', 'Sister', 'Brother')
	SET @ls_maternal_sibling_flag = 'Y'

IF @ps_relationship IN ('sibling', 'paternal sibling', 'paternal half sibling', 'Sister', 'Brother')
	SET @ls_paternal_sibling_flag = 'Y'

IF @ps_relationship IN ('parent', 'Mother', 'Father', 'Biological Mother', 'Biological Father')
	SET @ls_parent_flag = 'Y'

IF @ps_relationship = 'guardian'
	SET @ls_guardian_flag = 'Y'


INSERT INTO dbo.p_Patient_Relation (
	[cpr_id]
	,[relation_cpr_id]
	,[relationship]
	,[maternal_sibling_flag]
	,[paternal_sibling_flag]
	,[parent_flag]
	,[guardian_flag]
	,[guarantor_flag]
	,[payor_flag]
	,[primary_decision_maker_flag]
	,[created]
	,[created_by]
	,[status]
	,[status_date])
VALUES (
	@ps_cpr_id ,
	@ps_relation_cpr_id ,
	@ps_relationship ,
	@ls_maternal_sibling_flag ,
	@ls_paternal_sibling_flag ,
	@ls_parent_flag ,
	@ls_guardian_flag ,
	@ls_guarantor_flag ,
	@ls_payor_flag ,
	@ls_primary_decision_maker_flag ,
	getdate(),
	@ps_created_by,
	'OK',
	getdate())




