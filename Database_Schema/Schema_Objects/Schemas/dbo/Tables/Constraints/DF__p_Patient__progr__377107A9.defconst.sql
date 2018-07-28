ALTER TABLE [dbo].[p_Patient_Progress]
    ADD CONSTRAINT [DF__p_Patient__progr__377107A9] DEFAULT (getdate()) FOR [progress_date_time];

