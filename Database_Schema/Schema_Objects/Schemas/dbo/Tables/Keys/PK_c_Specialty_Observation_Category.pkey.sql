ALTER TABLE [dbo].[c_Specialty_Observation_Category]
    ADD CONSTRAINT [PK_c_Specialty_Observation_Category] PRIMARY KEY CLUSTERED ([specialty_id] ASC, [treatment_type] ASC, [observation_category_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

