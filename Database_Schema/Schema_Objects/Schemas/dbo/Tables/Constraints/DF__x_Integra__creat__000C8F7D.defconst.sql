ALTER TABLE [dbo].[x_Integration_Operation]
    ADD CONSTRAINT [DF__x_Integra__creat__000C8F7D] DEFAULT (getdate()) FOR [created];

