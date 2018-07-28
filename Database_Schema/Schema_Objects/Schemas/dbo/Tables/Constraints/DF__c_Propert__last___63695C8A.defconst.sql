ALTER TABLE [dbo].[c_Property]
    ADD CONSTRAINT [DF__c_Propert__last___63695C8A] DEFAULT (getdate()) FOR [last_updated];

