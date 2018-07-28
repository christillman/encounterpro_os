ALTER TABLE [dbo].[c_Preference]
    ADD CONSTRAINT [DF__c_Preference_id_50] DEFAULT (newid()) FOR [id];

