ALTER TABLE [dbo].[c_Maintenance_Protocol_Item]
    ADD CONSTRAINT [PK_c_Maintenance_Protocol_Item] PRIMARY KEY CLUSTERED ([maintenance_rule_id] ASC, [protocol_sequence] ASC, [protocol_item_sequence] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

