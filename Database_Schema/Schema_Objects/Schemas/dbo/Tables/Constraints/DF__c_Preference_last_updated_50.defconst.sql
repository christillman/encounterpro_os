ALTER TABLE [dbo].[c_Preference]
    ADD CONSTRAINT [DF__c_Preference_last_updated_50] DEFAULT (getdate()) FOR [last_updated];

