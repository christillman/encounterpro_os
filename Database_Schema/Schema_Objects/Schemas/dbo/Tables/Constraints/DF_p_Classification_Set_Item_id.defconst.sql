ALTER TABLE [dbo].[p_Classification_Set_Item]
    ADD CONSTRAINT [DF_p_Classification_Set_Item_id] DEFAULT (newid()) FOR [id];

