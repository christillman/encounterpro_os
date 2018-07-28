ALTER TABLE [dbo].[p_Material_Used]
    ADD CONSTRAINT [DF_p_material_21] DEFAULT (getdate()) FOR [created];

