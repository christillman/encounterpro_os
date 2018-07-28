ALTER TABLE [dbo].[c_Attachment_Type]
    ADD CONSTRAINT [DF__c_Attachment__id__08F5448B] DEFAULT (newid()) FOR [id];

