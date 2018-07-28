ALTER TABLE [dbo].[p_Observation_Result]
    ADD CONSTRAINT [DF__p_Obs_result_curflg] DEFAULT ('Y') FOR [current_flag];

