ALTER TABLE [dbo].[x_Message_Type]
    ADD CONSTRAINT [DF_x_Message_Type_id_40] DEFAULT (newid()) FOR [id];

