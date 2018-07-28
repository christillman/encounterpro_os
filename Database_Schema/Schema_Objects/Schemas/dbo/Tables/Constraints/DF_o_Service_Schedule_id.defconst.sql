ALTER TABLE [dbo].[o_Service_Schedule]
    ADD CONSTRAINT [DF_o_Service_Schedule_id] DEFAULT (newid()) FOR [id];

