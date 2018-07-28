ALTER TABLE [dbo].[p_Patient_Alias]
    ADD CONSTRAINT [DF_p_Patient_Alias_status] DEFAULT ('Y') FOR [current_flag];

