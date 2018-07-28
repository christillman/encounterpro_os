ALTER TABLE [dbo].[c_Menu]
    ADD CONSTRAINT [DF__c_Menu__last_upd__5AD41689] DEFAULT (getdate()) FOR [last_updated];

