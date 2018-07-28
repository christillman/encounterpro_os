ALTER TABLE [dbo].[p_Chart_Alert_Progress]
    ADD CONSTRAINT [DF_p_Cht_Alrt_Progress_d_t] DEFAULT (getdate()) FOR [progress_date_time];

