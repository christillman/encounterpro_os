ALTER TABLE [dbo].[x_Performance_Log]
    ADD CONSTRAINT [DF_x_Performance_Log_log_date_time_21] DEFAULT (getdate()) FOR [log_date_time];

