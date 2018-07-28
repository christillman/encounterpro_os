ALTER TABLE [dbo].[c_Maintenance_Treatment]
    ADD CONSTRAINT [PK_c_Maintenance_Treatment] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [maintenance_treatment_sequence] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

