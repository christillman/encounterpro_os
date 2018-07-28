ALTER TABLE [dbo].[c_Chart]
    ADD CONSTRAINT [DF__c_Chart__last_up__608CEFDF] DEFAULT (getdate()) FOR [last_updated];

