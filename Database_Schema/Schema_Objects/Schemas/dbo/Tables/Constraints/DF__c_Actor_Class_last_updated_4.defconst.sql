ALTER TABLE [dbo].[c_Actor_Class]
    ADD CONSTRAINT [DF__c_Actor_Class_last_updated_4] DEFAULT (getdate()) FOR [last_updated];

