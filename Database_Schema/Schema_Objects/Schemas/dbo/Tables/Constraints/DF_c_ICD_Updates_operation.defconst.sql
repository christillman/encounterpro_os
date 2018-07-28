ALTER TABLE [dbo].[c_ICD_Updates]
    ADD CONSTRAINT [DF_c_ICD_Updates_operation] DEFAULT ('New') FOR [operation];

