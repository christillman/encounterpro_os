ALTER TABLE [dbo].[p_Family_Illness]
    ADD CONSTRAINT [PK_p_Family_Illness_1__12] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [family_history_sequence] ASC, [family_illness_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

