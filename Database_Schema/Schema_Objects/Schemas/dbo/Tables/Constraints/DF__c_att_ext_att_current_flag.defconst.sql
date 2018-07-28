ALTER TABLE [dbo].[c_Attachment_Extension_Attribute]
    ADD CONSTRAINT [DF__c_att_ext_att_current_flag] DEFAULT ('Y') FOR [current_flag];

