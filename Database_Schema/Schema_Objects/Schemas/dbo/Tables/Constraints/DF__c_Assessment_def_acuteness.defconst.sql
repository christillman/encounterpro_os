ALTER TABLE [dbo].[c_Assessment_Definition]
    ADD CONSTRAINT [DF__c_Assessment_def_acuteness] DEFAULT ('Acute') FOR [acuteness];

