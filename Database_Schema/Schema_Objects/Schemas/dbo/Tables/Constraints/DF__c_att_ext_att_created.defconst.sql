ALTER TABLE [dbo].[c_Attachment_Extension_Attribute]
    ADD CONSTRAINT [DF__c_att_ext_att_created] DEFAULT (getdate()) FOR [created];

