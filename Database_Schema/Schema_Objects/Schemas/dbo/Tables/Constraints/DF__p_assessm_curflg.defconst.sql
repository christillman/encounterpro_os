ALTER TABLE [dbo].[p_Assessment]
    ADD CONSTRAINT [DF__p_assessm_curflg] DEFAULT ('Y') FOR [current_flag];

