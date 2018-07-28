ALTER TABLE [dbo].[p_Maintenance_Class]
    ADD CONSTRAINT [DF_p_Maintenance_Class_is_controlled_flag] DEFAULT ('X') FOR [is_controlled];

