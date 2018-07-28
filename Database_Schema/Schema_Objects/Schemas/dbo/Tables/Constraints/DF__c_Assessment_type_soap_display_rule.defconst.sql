ALTER TABLE [dbo].[c_Assessment_Type]
    ADD CONSTRAINT [DF__c_Assessment_type_soap_display_rule] DEFAULT ('Display Always') FOR [soap_display_rule];

