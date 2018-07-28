ALTER TABLE [dbo].[c_Disease]
    ADD CONSTRAINT [DF_c_Disease_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

