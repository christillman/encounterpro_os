ALTER TABLE [dbo].[x_External_Application_Message]
    ADD CONSTRAINT [DF_x_ext_appl_message_status_40] DEFAULT ('OK') FOR [status];

