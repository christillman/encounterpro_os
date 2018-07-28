ALTER TABLE [dbo].[p_Maintenance_Class]
    ADD CONSTRAINT [PK_p_Maintenance_Class] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [status_date] ASC, [cpr_id] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

