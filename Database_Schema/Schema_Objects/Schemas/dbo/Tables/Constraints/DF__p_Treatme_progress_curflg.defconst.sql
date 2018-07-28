ALTER TABLE [dbo].[p_Treatment_Progress]
    ADD CONSTRAINT [DF__p_Treatme_progress_curflg] DEFAULT ('Y') FOR [current_flag];

