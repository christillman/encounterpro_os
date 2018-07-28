ALTER TABLE [dbo].[c_Classification_Set]
    ADD CONSTRAINT [DF_c_Classification_Set_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

