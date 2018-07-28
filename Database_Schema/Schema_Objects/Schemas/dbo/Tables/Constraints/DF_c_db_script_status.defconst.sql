ALTER TABLE [dbo].[c_Database_Script]
    ADD CONSTRAINT [DF_c_db_script_status] DEFAULT ('OK') FOR [status];

