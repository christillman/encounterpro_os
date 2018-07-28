ALTER TABLE [dbo].[p_Material_Used]
    ADD CONSTRAINT [PK_p_Material_Used_1__12] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [encounter_id] ASC, [treatment_sequence] ASC, [material_id] ASC, [material_item_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

