ALTER TABLE [dbo].[p_Patient_WP]
    ADD CONSTRAINT [DF_p_Patient_Workplan_status] DEFAULT ('Pending') FOR [status];

