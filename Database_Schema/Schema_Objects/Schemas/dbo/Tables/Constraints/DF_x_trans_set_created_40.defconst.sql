ALTER TABLE [dbo].[x_Translation_Set]
    ADD CONSTRAINT [DF_x_trans_set_created_40] DEFAULT (getdate()) FOR [created];

