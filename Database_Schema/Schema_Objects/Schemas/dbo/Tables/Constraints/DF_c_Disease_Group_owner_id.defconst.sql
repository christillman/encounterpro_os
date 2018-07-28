ALTER TABLE [dbo].[c_Disease_Group]
    ADD CONSTRAINT [DF_c_Disease_Group_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

