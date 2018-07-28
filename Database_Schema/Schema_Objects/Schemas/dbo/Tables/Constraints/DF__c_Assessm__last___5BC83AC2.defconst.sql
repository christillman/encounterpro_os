ALTER TABLE [dbo].[c_Assessment_Definition]
    ADD CONSTRAINT [DF__c_Assessm__last___5BC83AC2] DEFAULT (getdate()) FOR [last_updated];

