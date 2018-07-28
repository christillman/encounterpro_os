ALTER TABLE [dbo].[c_External_Source]
    ADD CONSTRAINT [DF_c_External_Source_owner] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

