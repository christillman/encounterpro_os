ALTER TABLE [dbo].[c_Config_Object]
    ADD CONSTRAINT [DF_c_Config_Object_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

