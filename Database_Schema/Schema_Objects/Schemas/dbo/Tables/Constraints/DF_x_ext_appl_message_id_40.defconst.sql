ALTER TABLE [dbo].[x_External_Application_Message]
    ADD CONSTRAINT [DF_x_ext_appl_message_id_40] DEFAULT (newid()) FOR [id];

