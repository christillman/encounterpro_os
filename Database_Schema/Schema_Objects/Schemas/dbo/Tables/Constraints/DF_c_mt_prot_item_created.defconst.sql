ALTER TABLE [dbo].[c_Maintenance_Protocol_Item]
    ADD CONSTRAINT [DF_c_mt_prot_item_created] DEFAULT (getdate()) FOR [created];

