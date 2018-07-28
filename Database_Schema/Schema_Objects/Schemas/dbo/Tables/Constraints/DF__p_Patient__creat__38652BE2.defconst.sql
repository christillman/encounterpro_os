ALTER TABLE [dbo].[p_Patient_Progress]
    ADD CONSTRAINT [DF__p_Patient__creat__38652BE2] DEFAULT (getdate()) FOR [created];

