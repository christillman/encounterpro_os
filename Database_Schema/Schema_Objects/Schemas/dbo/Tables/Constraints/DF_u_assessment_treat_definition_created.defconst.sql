ALTER TABLE [dbo].[u_assessment_treat_definition]
    ADD CONSTRAINT [DF_u_assessment_treat_definition_created] DEFAULT (getdate()) FOR [created];

