ALTER TABLE [dbo].[o_Treatment_Type_Default_Mode]
    ADD CONSTRAINT [PK_o_Treatment_Type_Def_Mode] PRIMARY KEY CLUSTERED ([treatment_type] ASC, [treatment_key] ASC, [office_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

