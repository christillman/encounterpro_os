ALTER TABLE [dbo].[c_Actor_Route_Purpose]
    ADD CONSTRAINT [DF_c_Actor_Route_Purpose_created] DEFAULT (getdate()) FOR [created];

