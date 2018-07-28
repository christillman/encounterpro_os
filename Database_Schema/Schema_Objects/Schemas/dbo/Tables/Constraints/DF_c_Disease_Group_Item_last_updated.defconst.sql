ALTER TABLE [dbo].[c_Disease_Group_Item]
    ADD CONSTRAINT [DF_c_Disease_Group_Item_last_updated] DEFAULT (getdate()) FOR [last_updated];

