ALTER TABLE [dbo].[c_XML_Class]
    ADD CONSTRAINT [DF_c_XML_Class_owner_id] DEFAULT ([dbo].[fn_customer_id]()) FOR [owner_id];

