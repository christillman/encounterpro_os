ALTER TABLE [dbo].[c_Database_Modification_Dependancy]
    ADD CONSTRAINT [DF_c_db_mode_dep_mod_level] DEFAULT ((0)) FOR [modification_level];

