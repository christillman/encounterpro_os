ALTER TABLE [dbo].[c_Maintenance_Policy]
    ADD CONSTRAINT [DF_c_mt_Policy_include_new_flag] DEFAULT ('N') FOR [include_new_flag];

