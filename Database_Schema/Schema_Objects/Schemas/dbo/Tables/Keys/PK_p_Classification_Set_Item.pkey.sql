ALTER TABLE [dbo].[p_Classification_Set_Item]
    ADD CONSTRAINT [PK_p_Classification_Set_Item] PRIMARY KEY NONCLUSTERED ([cpr_id] ASC, [classification_set_id] ASC, [item_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF) ON [PRIMARY];

