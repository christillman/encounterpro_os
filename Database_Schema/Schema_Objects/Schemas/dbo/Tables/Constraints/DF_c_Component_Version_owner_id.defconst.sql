ALTER TABLE [dbo].[c_Component_Version]
    ADD CONSTRAINT [DF_c_Component_Version_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

