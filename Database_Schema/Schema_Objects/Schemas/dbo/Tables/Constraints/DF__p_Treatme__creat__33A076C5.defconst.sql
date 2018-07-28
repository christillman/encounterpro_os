ALTER TABLE [dbo].[p_Treatment_Progress]
    ADD CONSTRAINT [DF__p_Treatme__creat__33A076C5] DEFAULT (getdate()) FOR [created];

