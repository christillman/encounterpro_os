ALTER TABLE [dbo].[c_Workplan]
    ADD CONSTRAINT [DF__c_Workpla__last___59DFF250] DEFAULT (getdate()) FOR [last_updated];

