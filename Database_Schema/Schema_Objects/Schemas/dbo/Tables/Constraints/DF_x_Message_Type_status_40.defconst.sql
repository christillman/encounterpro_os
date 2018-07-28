ALTER TABLE [dbo].[x_Message_Type]
    ADD CONSTRAINT [DF_x_Message_Type_status_40] DEFAULT ('OK') FOR [status];

