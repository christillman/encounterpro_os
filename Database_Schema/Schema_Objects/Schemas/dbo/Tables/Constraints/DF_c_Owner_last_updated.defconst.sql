ALTER TABLE [dbo].[c_Owner]
    ADD CONSTRAINT [DF_c_Owner_last_updated] DEFAULT (getdate()) FOR [last_updated];

