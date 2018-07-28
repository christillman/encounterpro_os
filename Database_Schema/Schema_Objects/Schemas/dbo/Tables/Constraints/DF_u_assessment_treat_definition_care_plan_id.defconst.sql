ALTER TABLE [dbo].[u_assessment_treat_definition]
    ADD CONSTRAINT [DF_u_assessment_treat_definition_care_plan_id] DEFAULT ((0)) FOR [care_plan_id];

