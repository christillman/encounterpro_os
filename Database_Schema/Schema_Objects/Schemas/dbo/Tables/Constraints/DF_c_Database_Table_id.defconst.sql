ALTER TABLE [dbo].[c_Database_Table]
    ADD CONSTRAINT [DF_c_Database_Table_id] DEFAULT (newid()) FOR [id];

