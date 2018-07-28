ALTER TABLE [dbo].[x_External_Application]
    ADD CONSTRAINT [DF__x_Externa__creat__76832543] DEFAULT (getdate()) FOR [created];

