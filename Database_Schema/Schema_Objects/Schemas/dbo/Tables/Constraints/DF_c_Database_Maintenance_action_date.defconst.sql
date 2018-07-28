ALTER TABLE [dbo].[c_Database_Maintenance]
    ADD CONSTRAINT [DF_c_Database_Maintenance_action_date] DEFAULT (getdate()) FOR [action_date];

