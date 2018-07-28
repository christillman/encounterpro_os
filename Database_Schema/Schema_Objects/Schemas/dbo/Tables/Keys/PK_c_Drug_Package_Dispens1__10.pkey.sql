ALTER TABLE [dbo].[c_Drug_Package_Dispense]
    ADD CONSTRAINT [PK_c_Drug_Package_Dispens1__10] PRIMARY KEY CLUSTERED ([drug_id] ASC, [package_id] ASC, [dispense_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

