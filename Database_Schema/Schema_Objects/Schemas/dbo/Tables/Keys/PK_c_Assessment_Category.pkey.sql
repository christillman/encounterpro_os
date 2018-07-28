ALTER TABLE [dbo].[c_Assessment_Category]
    ADD CONSTRAINT [PK_c_Assessment_Category] PRIMARY KEY CLUSTERED ([assessment_type] ASC, [assessment_category_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

