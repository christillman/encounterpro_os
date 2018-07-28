ALTER TABLE [dbo].[p_Observation_Result_Progress]
    ADD CONSTRAINT [PK_p_obs_res_prg_127] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [observation_sequence] ASC, [location_result_sequence] ASC, [result_progress_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

