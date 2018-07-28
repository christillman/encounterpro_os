ALTER TABLE [dbo].[c_Config_Log]
    ADD CONSTRAINT [DF_c_Config_Log_operation_datetime] DEFAULT (getdate()) FOR [operation_datetime];

