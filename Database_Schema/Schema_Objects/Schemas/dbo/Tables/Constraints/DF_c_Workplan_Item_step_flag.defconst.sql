ALTER TABLE [dbo].[c_Workplan_Item]
    ADD CONSTRAINT [DF_c_Workplan_Item_step_flag] DEFAULT ('Y') FOR [step_flag];

