ALTER TABLE [dbo].[p_Attachment_Progress]
    ADD CONSTRAINT [DF__p_att_progress_curflg] DEFAULT ('Y') FOR [current_flag];

