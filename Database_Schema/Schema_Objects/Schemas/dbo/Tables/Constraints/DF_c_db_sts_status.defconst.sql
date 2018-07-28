ALTER TABLE [dbo].[c_Database_Status]
    ADD CONSTRAINT [DF_c_db_sts_status] DEFAULT ('OK') FOR [database_status];

