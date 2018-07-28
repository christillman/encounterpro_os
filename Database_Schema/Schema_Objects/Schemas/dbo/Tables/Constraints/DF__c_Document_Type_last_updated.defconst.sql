ALTER TABLE [dbo].[c_Document_Type]
    ADD CONSTRAINT [DF__c_Document_Type_last_updated] DEFAULT (getdate()) FOR [last_updated];

