ALTER TABLE [dbo].[c_Actor_Route_Purpose]
    ADD CONSTRAINT [DF_c_Actor_Route_Purpose_status] DEFAULT ('Y') FOR [current_flag];

