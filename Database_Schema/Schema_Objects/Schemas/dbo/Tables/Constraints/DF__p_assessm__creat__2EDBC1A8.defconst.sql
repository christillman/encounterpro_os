ALTER TABLE [dbo].[p_assessment_Progress]
    ADD CONSTRAINT [DF__p_assessm__creat__2EDBC1A8] DEFAULT (getdate()) FOR [created];

