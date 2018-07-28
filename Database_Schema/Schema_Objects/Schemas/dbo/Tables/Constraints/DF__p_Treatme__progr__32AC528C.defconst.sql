ALTER TABLE [dbo].[p_Treatment_Progress]
    ADD CONSTRAINT [DF__p_Treatme__progr__32AC528C] DEFAULT (getdate()) FOR [progress_date_time];

