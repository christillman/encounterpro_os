ALTER TABLE [dbo].[c_Actor_Class_Route]
    ADD CONSTRAINT [DF__c_Actor_Class_Route_last_updated_4] DEFAULT (getdate()) FOR [last_updated];

