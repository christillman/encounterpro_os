ALTER TABLE [dbo].[c_Specialty]
    ADD CONSTRAINT [DF__c_Special__last___645D80C3] DEFAULT (getdate()) FOR [last_updated];

