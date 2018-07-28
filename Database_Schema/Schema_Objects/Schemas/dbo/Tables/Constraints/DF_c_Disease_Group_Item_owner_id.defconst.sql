ALTER TABLE [dbo].[c_Disease_Group_Item]
    ADD CONSTRAINT [DF_c_Disease_Group_Item_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

