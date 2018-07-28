ALTER TABLE [dbo].[x_Translation_Set]
    ADD CONSTRAINT [DF_x_Trans_set_id_40] DEFAULT (newid()) FOR [id];

