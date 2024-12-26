
Print 'Drop View [dbo].[v_Encounter_Assessment_Charge]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[v_Encounter_Assessment_Charge]') AND [type]='V'))
DROP VIEW v_Encounter_Assessment_Charge
Print 'Create View [dbo].[v_Encounter_Assessment_Charge]'
GO
CREATE VIEW v_Encounter_Assessment_Charge AS
SELECT eac.cpr_id
	,eac.encounter_id
	,eac.problem_id
	,eac.encounter_charge_id
	,eac.bill_flag as eac_bill_flag
	,eac.created
	,pea.assessment_id
	,pea.assessment_sequence
	,pea.assessment_billing_id
	,pea.bill_flag as pea_bill_flag
	,a.assessment
	,a.assessment_status
	,a.assessment_type
	,a.diagnosis_sequence
	,a.begin_date
	,a.end_date
	,a.attachment_id
	,ec.bill_flag as ec_bill_flag
	,ec.procedure_id
	,ca.icd_9_code
	,ca.icd10_code
	,cp.cpt_code
	,cp.modifier
	,cp.charge
	,cp.procedure_category_id
	,cp.risk_level
FROM p_Encounter_Assessment_Charge eac (NOLOCK)
    JOIN p_Encounter_Assessment pea (NOLOCK) ON eac.cpr_id = pea.cpr_id
		AND eac.encounter_id = pea.encounter_id
    JOIN p_Assessment a (NOLOCK) ON pea.problem_id = a.problem_id
		AND eac.problem_id = a.problem_id
    JOIN p_Encounter_Charge ec (NOLOCK) ON pea.cpr_id = ec.cpr_id
		AND pea.encounter_id = ec.encounter_id
		AND eac.encounter_charge_id = ec.encounter_charge_id
    JOIN c_Assessment_definition ca (NOLOCK) ON a.assessment_id = ca.assessment_id
    JOIN p_Assessment_Treatment pat (NOLOCK) ON a.cpr_id = pat.cpr_id
		AND a.problem_id = pat.problem_id
    JOIN c_procedure cp (NOLOCK) ON cp.procedure_id = ec.procedure_id  
GO

