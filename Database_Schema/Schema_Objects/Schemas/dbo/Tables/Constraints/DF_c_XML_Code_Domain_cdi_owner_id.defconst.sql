ALTER TABLE [dbo].[c_XML_Code_Domain_Item]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_cdi_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [code_domain_item_owner_id];

