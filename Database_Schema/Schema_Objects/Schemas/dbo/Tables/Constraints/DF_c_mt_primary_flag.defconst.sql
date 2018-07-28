ALTER TABLE [dbo].[c_Maintenance_Treatment]
    ADD CONSTRAINT [DF_c_mt_primary_flag] DEFAULT ('N') FOR [primary_flag];

