ALTER TABLE [dbo].[p_Maintenance_Class]
    ADD CONSTRAINT [DF_p_Maintenance_Class_on_protocol_flag] DEFAULT ('N') FOR [on_protocol_flag];

