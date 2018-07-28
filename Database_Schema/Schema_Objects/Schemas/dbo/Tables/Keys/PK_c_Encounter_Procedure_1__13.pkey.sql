ALTER TABLE [dbo].[c_Encounter_Procedure]
    ADD CONSTRAINT [PK_c_Encounter_Procedure_1__13] PRIMARY KEY CLUSTERED ([encounter_type] ASC, [new_flag] ASC, [procedure_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

