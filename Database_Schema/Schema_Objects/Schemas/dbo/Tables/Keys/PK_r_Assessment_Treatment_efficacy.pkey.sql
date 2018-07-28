ALTER TABLE [dbo].[r_Assessment_Treatment_Efficacy]
    ADD CONSTRAINT [PK_r_Assessment_Treatment_efficacy] PRIMARY KEY CLUSTERED ([assessment_id] ASC, [treatment_type] ASC, [treatment_key] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

