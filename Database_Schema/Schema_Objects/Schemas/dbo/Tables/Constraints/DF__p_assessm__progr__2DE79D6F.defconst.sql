ALTER TABLE [dbo].[p_assessment_Progress]
    ADD CONSTRAINT [DF__p_assessm__progr__2DE79D6F] DEFAULT (getdate()) FOR [progress_date_time];

