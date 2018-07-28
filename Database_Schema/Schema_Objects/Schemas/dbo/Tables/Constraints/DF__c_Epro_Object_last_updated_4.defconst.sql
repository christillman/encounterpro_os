ALTER TABLE [dbo].[c_Epro_Object]
    ADD CONSTRAINT [DF__c_Epro_Object_last_updated_4] DEFAULT (getdate()) FOR [last_updated];

