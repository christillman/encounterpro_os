ALTER TABLE [dbo].[x_Translation_Set]
    ADD CONSTRAINT [DF_x_trans_set_status_40] DEFAULT ('OK') FOR [status];

