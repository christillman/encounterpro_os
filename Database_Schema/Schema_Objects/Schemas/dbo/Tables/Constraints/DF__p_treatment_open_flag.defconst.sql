ALTER TABLE [dbo].[p_Treatment_Item]
    ADD CONSTRAINT [DF__p_treatment_open_flag] DEFAULT ('Y') FOR [open_flag];

