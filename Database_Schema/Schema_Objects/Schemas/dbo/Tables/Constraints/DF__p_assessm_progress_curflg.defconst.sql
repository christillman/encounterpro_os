ALTER TABLE [dbo].[p_assessment_Progress]
    ADD CONSTRAINT [DF__p_assessm_progress_curflg] DEFAULT ('Y') FOR [current_flag];

