ALTER TABLE [dbo].[c_Disease_Group_Item]
    ADD CONSTRAINT [DF_c_Disease_Group_Item_id] DEFAULT (newid()) FOR [id];

