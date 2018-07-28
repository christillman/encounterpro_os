ALTER TABLE [dbo].[p_Maintenance_Class]
    ADD CONSTRAINT [DF_p_Maintenance_Class_in_class_flag] DEFAULT ('N') FOR [in_class_flag];

