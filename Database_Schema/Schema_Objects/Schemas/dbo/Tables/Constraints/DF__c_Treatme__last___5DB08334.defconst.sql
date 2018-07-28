ALTER TABLE [dbo].[c_Treatment_Type]
    ADD CONSTRAINT [DF__c_Treatme__last___5DB08334] DEFAULT (getdate()) FOR [last_updated];

