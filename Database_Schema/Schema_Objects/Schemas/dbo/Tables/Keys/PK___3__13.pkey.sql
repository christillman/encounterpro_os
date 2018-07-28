ALTER TABLE [dbo].[c_Observation_Result_Qualifier]
    ADD CONSTRAINT [PK___3__13] PRIMARY KEY CLUSTERED ([observation_id] ASC, [result_sequence] ASC, [qualifier_domain_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

