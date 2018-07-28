ALTER TABLE [dbo].[c_Actor_Class_Route]
    ADD CONSTRAINT [DF__c_Actor_Class_Route_id_4] DEFAULT (newid()) FOR [id];

