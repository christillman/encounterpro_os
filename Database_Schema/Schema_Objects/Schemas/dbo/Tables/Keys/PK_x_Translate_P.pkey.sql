ALTER TABLE [dbo].[x_Translate_P]
    ADD CONSTRAINT [PK_x_Translate_P] PRIMARY KEY CLUSTERED ([translation_set] ASC, [cpr_id] ASC, [epro_value] ASC, [external_value] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

