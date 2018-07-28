ALTER TABLE [dbo].[c_Owner]
    ADD CONSTRAINT [DF_c_Owner_created] DEFAULT (getdate()) FOR [created];

