ALTER TABLE [dbo].[p_Chart_Alert]
    ADD CONSTRAINT [DF_p_Chart_Alert_created] DEFAULT (getdate()) FOR [created];

