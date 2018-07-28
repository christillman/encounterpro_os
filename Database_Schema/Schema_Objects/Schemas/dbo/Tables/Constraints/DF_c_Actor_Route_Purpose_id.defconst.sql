ALTER TABLE [dbo].[c_Actor_Route_Purpose]
    ADD CONSTRAINT [DF_c_Actor_Route_Purpose_id] DEFAULT (newid()) FOR [id];

