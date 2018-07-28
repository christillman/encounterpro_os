ALTER TABLE [dbo].[p_Observation]
    ADD CONSTRAINT [DF_p_Obs40_res_exp_21] DEFAULT (getdate()) FOR [result_expected_date];

