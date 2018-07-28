ALTER TABLE [dbo].[p_Patient_WP_Item_Attribute]
    ADD CONSTRAINT [DF_p_Patient_WP_Item_Attribute_created] DEFAULT (getdate()) FOR [created];

