ALTER TABLE [dbo].[c_Maintenance_Metric]
    ADD CONSTRAINT [PK_c_Maintenance_Metric] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [metric_sequence] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

