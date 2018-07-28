ALTER TABLE [dbo].[c_Database_Status]
    ADD CONSTRAINT [DF_c_db_sts_id] DEFAULT (newid()) FOR [database_id];

