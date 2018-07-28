ALTER TABLE [dbo].[c_Menu_Item]
    ADD CONSTRAINT [DF_c_Menu_Item_id_129] DEFAULT (newid()) FOR [id];

