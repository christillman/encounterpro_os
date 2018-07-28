ALTER TABLE [dbo].[c_Document_Type]
    ADD CONSTRAINT [DF__c_Document_Type_status] DEFAULT ('OK') FOR [status];

