ALTER TABLE [dbo].[c_Specialty_Procedure_Category]
    ADD CONSTRAINT [PK_c_Specialty_Procedure_Category] PRIMARY KEY CLUSTERED ([specialty_id] ASC, [procedure_type] ASC, [procedure_category_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

