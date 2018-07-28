ALTER TABLE [dbo].[x_External_Application_Message]
    ADD CONSTRAINT [PK_x_External_Application_Message_40] PRIMARY KEY CLUSTERED ([external_application_id] ASC, [message_type] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

