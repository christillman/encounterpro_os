ALTER TABLE [dbo].[o_Service_Schedule]
    ADD CONSTRAINT [DF_o_Service_Schedule_created] DEFAULT (getdate()) FOR [created];

