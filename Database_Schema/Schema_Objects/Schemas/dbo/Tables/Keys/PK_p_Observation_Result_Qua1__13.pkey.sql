ALTER TABLE [dbo].[p_Observation_Result_Qualifier]
    ADD CONSTRAINT [PK_p_Observation_Result_Qua1__13] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [treatment_id] ASC, [observation_sequence] ASC, [location] ASC, [result_sequence] ASC, [qualifier_domain_id] ASC, [qualifier] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

