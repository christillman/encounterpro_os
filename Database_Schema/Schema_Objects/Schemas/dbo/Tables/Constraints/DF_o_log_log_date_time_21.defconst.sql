ALTER TABLE [dbo].[o_Log]
    ADD CONSTRAINT [DF_o_log_log_date_time_21] DEFAULT (getdate()) FOR [log_date_time];

