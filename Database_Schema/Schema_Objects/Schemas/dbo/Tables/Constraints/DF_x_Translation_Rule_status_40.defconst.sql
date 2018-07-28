ALTER TABLE [dbo].[x_Translation_Rule]
    ADD CONSTRAINT [DF_x_Translation_Rule_status_40] DEFAULT ('OK') FOR [status];

