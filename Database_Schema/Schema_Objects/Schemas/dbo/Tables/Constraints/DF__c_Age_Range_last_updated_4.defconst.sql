ALTER TABLE [dbo].[c_Age_Range]
    ADD CONSTRAINT [DF__c_Age_Range_last_updated_4] DEFAULT (getdate()) FOR [last_updated];

