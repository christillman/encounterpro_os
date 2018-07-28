ALTER TABLE [dbo].[c_XML_Code]
    ADD CONSTRAINT [DF_c_XML_Code_epro_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [epro_owner_id];

