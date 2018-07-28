ALTER TABLE [dbo].[c_Age_Range]
    ADD CONSTRAINT [DF__c_Age_Range_id_4] DEFAULT (newid()) FOR [id];

