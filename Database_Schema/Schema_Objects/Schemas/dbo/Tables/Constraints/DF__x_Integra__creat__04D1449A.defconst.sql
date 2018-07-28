ALTER TABLE [dbo].[x_Integration_Operation_Tree]
    ADD CONSTRAINT [DF__x_Integra__creat__04D1449A] DEFAULT (getdate()) FOR [created];

