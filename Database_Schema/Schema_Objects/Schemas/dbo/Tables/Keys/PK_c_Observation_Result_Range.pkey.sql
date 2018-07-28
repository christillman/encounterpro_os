ALTER TABLE [dbo].[c_Observation_Result_Range]
    ADD CONSTRAINT [PK_c_Observation_Result_Range] PRIMARY KEY CLUSTERED ([observation_id] ASC, [result_sequence] ASC, [result_range_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

