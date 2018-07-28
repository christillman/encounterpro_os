ALTER TABLE [dbo].[c_CPT_Updates]
    ADD CONSTRAINT [DF_c_CPT_Updates_operation] DEFAULT ('New') FOR [operation];

