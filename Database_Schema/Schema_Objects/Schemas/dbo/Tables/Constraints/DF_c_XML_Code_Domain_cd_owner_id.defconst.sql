ALTER TABLE [dbo].[c_XML_Code_Domain]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_cd_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [code_domain_owner_id];

