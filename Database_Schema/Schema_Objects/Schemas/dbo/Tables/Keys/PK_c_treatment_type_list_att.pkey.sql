ALTER TABLE [dbo].[c_Treatment_Type_List_Attribute]
    ADD CONSTRAINT [PK_c_treatment_type_list_att] PRIMARY KEY CLUSTERED ([treatment_list_id] ASC, [list_sequence] ASC, [attribute] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

