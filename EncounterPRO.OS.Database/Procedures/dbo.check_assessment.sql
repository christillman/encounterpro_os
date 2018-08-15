
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[check_assessment]') AND [type]='P'))
	DROP PROCEDURE [dbo].check_assessment
GO

CREATE PROCEDURE check_assessment (@ps_assessment_id varchar(24))
AS
CREATE TABLE #results (table_column varchar(128), cnt integer)
INSERT INTO #results SELECT 'c_Assessment_Definition.assessment_id', count(*) FROM c_Assessment_Definition WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Allergy_Drug.assessment_id', count(*) FROM c_Allergy_Drug WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Maintenance_Protocol_Item.assessment_id', count(*) FROM c_Maintenance_Protocol_Item WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Risk_Factor.assessment_id', count(*) FROM c_Risk_Factor WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Disease_Assessment.assessment_id', count(*) FROM c_Disease_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Equivalence.object_key', count(*) FROM c_Equivalence WHERE object_key = @ps_assessment_id
INSERT INTO #results SELECT 'c_Menu_Item_Attribute.value', count(*) FROM c_Menu_Item_Attribute WHERE value = @ps_assessment_id
INSERT INTO #results SELECT 'r_Efficacy_Data.assessment_id', count(*) FROM r_Efficacy_Data WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Assessment_Coding.assessment_id', count(*) FROM c_Assessment_Coding WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Maintenance_Assessment.assessment_id', count(*) FROM c_Maintenance_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Reccomended_Observation.assessment_id', count(*) FROM c_Reccomended_Observation WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Age_Range_Assessment.assessment_id', count(*) FROM c_Age_Range_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Common_Assessment.assessment_id', count(*) FROM c_Common_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Procedure.bill_assessment_id', count(*) FROM c_Procedure WHERE bill_assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Workplan.assessment_id', count(*) FROM c_Workplan WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'c_Workplan_Item_Attribute.value', count(*) FROM c_Workplan_Item_Attribute WHERE value = @ps_assessment_id
INSERT INTO #results SELECT 'p_Assessment.assessment_id', count(*) FROM p_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'p_Encounter_Assessment.assessment_id', count(*) FROM p_Encounter_Assessment WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'p_Family_Illness.assessment_id', count(*) FROM p_Family_Illness WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'r_Assessment_Treatment_Efficacy.assessment_id', count(*) FROM r_Assessment_Treatment_Efficacy WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'u_assessment_treat_definition.assessment_id', count(*) FROM u_assessment_treat_definition WHERE assessment_id = @ps_assessment_id
INSERT INTO #results SELECT 'u_top_20.item_id', count(*) FROM u_top_20 WHERE item_id = @ps_assessment_id

SELECT * FROM #results
WHERE cnt > 0
ORDER BY table_column

go


-- EXEC check_assessment 'DEMO716'
