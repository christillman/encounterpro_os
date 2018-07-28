ALTER TABLE [dbo].[c_Workplan]
    ADD CONSTRAINT [DF_c_Workplan_workplan_type] DEFAULT ('Patient') FOR [workplan_type];

