ALTER TABLE [dbo].[c_Maintenance_Metric]
    ADD CONSTRAINT [DF_c_mt_Metric_created] DEFAULT (getdate()) FOR [created];

