ALTER TABLE [dbo].[c_Maintenance_Policy]
    ADD CONSTRAINT [DF_c_mt_Policy_created] DEFAULT (getdate()) FOR [created];

