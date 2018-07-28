ALTER TABLE [dbo].[c_Document_Route]
    ADD CONSTRAINT [DF__c_Document_Route_id_4] DEFAULT (newid()) FOR [id];

