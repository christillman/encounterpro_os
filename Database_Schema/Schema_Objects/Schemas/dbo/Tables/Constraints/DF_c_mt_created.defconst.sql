ALTER TABLE [dbo].[c_Maintenance_Treatment]
    ADD CONSTRAINT [DF_c_mt_created] DEFAULT (getdate()) FOR [created];

