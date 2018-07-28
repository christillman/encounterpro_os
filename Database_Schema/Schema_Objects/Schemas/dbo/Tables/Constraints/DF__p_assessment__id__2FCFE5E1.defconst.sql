ALTER TABLE [dbo].[p_assessment_Progress]
    ADD CONSTRAINT [DF__p_assessment__id__2FCFE5E1] DEFAULT (newid()) FOR [id];

