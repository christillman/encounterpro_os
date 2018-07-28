ALTER TABLE [dbo].[c_Procedure]
    ADD CONSTRAINT [DF__c_Procedu__last___5CBC5EFB] DEFAULT (getdate()) FOR [last_updated];

