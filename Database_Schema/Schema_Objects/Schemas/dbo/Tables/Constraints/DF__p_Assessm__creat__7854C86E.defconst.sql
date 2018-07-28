ALTER TABLE [dbo].[p_Assessment]
    ADD CONSTRAINT [DF__p_Assessm__creat__7854C86E] DEFAULT (getdate()) FOR [created];

