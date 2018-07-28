ALTER TABLE [dbo].[c_Epro_Object]
    ADD CONSTRAINT [DF__c_Epro_Object_id_4] DEFAULT (newid()) FOR [id];

