ALTER TABLE [dbo].[o_Message_Log]
    ADD CONSTRAINT [DF_o_Message__message_dat1__10] DEFAULT (getdate()) FOR [message_date_time];

