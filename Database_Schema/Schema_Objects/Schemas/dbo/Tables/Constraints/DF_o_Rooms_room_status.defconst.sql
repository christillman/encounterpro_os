ALTER TABLE [dbo].[o_Rooms]
    ADD CONSTRAINT [DF_o_Rooms_room_status] DEFAULT ('OK') FOR [room_status];

