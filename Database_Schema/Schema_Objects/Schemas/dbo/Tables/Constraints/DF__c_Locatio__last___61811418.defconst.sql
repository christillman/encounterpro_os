ALTER TABLE [dbo].[c_Location_Domain]
    ADD CONSTRAINT [DF__c_Locatio__last___61811418] DEFAULT (getdate()) FOR [last_updated];

