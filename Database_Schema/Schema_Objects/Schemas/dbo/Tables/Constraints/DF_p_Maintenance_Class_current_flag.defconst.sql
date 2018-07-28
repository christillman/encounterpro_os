ALTER TABLE [dbo].[p_Maintenance_Class]
    ADD CONSTRAINT [DF_p_Maintenance_Class_current_flag] DEFAULT ('Y') FOR [current_flag];

