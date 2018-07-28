ALTER TABLE [dbo].[c_Database_Status]
    ADD CONSTRAINT [DF_c_db_sts_beta_flag] DEFAULT ((0)) FOR [beta_flag];

