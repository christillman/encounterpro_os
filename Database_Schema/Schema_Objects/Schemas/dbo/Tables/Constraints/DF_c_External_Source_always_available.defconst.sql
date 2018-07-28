ALTER TABLE [dbo].[c_External_Source]
    ADD CONSTRAINT [DF_c_External_Source_always_available] DEFAULT ((0)) FOR [always_available];

