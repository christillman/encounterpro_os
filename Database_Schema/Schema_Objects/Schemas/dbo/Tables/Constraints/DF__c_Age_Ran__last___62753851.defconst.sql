ALTER TABLE [dbo].[c_Age_Range_Category]
    ADD CONSTRAINT [DF__c_Age_Ran__last___62753851] DEFAULT (getdate()) FOR [last_updated];

