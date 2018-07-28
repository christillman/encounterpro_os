ALTER TABLE [dbo].[x_Message_Type]
    ADD CONSTRAINT [DF_x_Message_Type_created_40] DEFAULT (getdate()) FOR [created];

