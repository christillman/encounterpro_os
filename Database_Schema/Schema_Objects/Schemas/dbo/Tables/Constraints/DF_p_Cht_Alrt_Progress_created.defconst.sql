ALTER TABLE [dbo].[p_Chart_Alert_Progress]
    ADD CONSTRAINT [DF_p_Cht_Alrt_Progress_created] DEFAULT (getdate()) FOR [created];

