ALTER TABLE [dbo].[c_Actor_Class]
    ADD CONSTRAINT [DF__c_Actor_Class_id_4] DEFAULT (newid()) FOR [id];

