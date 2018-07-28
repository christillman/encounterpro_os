ALTER TABLE [dbo].[x_Integrations]
    ADD CONSTRAINT [DF_x_Integrations_Enabled] DEFAULT ('Y') FOR [Enabled];

