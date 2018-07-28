ALTER TABLE [dbo].[p_Treatment_Item]
    ADD CONSTRAINT [DF__p_Treatme__creat__75235608] DEFAULT (getdate()) FOR [created];

