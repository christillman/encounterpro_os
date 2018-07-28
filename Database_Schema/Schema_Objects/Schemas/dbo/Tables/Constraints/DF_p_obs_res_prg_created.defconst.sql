ALTER TABLE [dbo].[p_Observation_Result_Progress]
    ADD CONSTRAINT [DF_p_obs_res_prg_created] DEFAULT (getdate()) FOR [created];

