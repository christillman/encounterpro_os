ALTER TABLE [dbo].[c_Database_Table]
    ADD CONSTRAINT [DF_c_Database_Table_lastupd] DEFAULT (getdate()) FOR [last_update];

