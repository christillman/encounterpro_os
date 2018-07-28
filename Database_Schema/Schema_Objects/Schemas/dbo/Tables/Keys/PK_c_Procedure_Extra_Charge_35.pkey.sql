ALTER TABLE [dbo].[c_Procedure_Extra_Charge]
    ADD CONSTRAINT [PK_c_Procedure_Extra_Charge_35] PRIMARY KEY CLUSTERED ([procedure_id] ASC, [extra_procedure_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

