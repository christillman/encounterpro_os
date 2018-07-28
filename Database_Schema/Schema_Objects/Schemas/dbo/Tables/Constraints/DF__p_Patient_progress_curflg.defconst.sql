ALTER TABLE [dbo].[p_Patient_Progress]
    ADD CONSTRAINT [DF__p_Patient_progress_curflg] DEFAULT ('Y') FOR [current_flag];

