ALTER TABLE [dbo].[c_Database_Script]
    ADD CONSTRAINT [DF_c_db_allow_users] DEFAULT ((1)) FOR [allow_users];

