ALTER TABLE [dbo].[p_Assessment_Treatment]
    ADD CONSTRAINT [DF__p_Assessm__creat__7152C524] DEFAULT (getdate()) FOR [created];

