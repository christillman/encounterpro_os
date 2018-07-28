ALTER TABLE [dbo].[c_Actor_Address]
    ADD CONSTRAINT [DF_c_Actor_Address_created] DEFAULT (getdate()) FOR [created];

