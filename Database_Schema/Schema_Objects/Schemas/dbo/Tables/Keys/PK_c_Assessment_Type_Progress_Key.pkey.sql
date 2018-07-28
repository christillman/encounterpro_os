ALTER TABLE [dbo].[c_Assessment_Type_Progress_Key]
    ADD CONSTRAINT [PK_c_Assessment_Type_Progress_Key] PRIMARY KEY CLUSTERED ([assessment_type] ASC, [progress_type] ASC, [progress_key] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

