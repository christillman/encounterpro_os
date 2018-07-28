ALTER TABLE [dbo].[c_Database_Script]
    ADD CONSTRAINT [DF_c_db_script_id] DEFAULT (newid()) FOR [id];

