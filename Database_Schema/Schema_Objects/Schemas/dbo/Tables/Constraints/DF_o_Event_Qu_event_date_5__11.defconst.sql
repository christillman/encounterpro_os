ALTER TABLE [dbo].[o_Event_Queue]
    ADD CONSTRAINT [DF_o_Event_Qu_event_date_5__11] DEFAULT (getdate()) FOR [event_date_time];

