ALTER TABLE [dbo].[c_Document_Type]
    ADD CONSTRAINT [DF__c_Document_Type_owner_id] DEFAULT ((-1)) FOR [owner_id];

