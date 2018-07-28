ALTER TABLE [dbo].[c_Maintenance_Procedure]
    ADD CONSTRAINT [PK_c_Maintenance_Procedure_01] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [procedure_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

