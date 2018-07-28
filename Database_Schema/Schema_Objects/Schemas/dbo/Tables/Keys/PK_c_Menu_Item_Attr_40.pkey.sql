ALTER TABLE [dbo].[c_Menu_Item_Attribute]
    ADD CONSTRAINT [PK_c_Menu_Item_Attr_40] PRIMARY KEY CLUSTERED ([menu_id] ASC, [menu_item_id] ASC, [menu_item_attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

