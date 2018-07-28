ALTER TABLE [dbo].[c_Authority_Formulary]
    ADD CONSTRAINT [PK_c_Authority_Formulary] PRIMARY KEY CLUSTERED ([authority_id] ASC, [authority_formulary_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

