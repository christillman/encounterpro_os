ALTER TABLE [dbo].[p_Observation_Result_Progress]
    ADD CONSTRAINT [DF_p_Obs_res_prg_curflg] DEFAULT ('Y') FOR [current_flag];

