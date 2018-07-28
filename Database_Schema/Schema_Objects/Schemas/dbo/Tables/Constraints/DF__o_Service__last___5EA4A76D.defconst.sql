ALTER TABLE [dbo].[o_Service]
    ADD CONSTRAINT [DF__o_Service__last___5EA4A76D] DEFAULT (getdate()) FOR [last_updated];

