ALTER TABLE [dbo].[c_Maintenance_Protocol]
    ADD CONSTRAINT [DF_c_mt_protocol_created] DEFAULT (getdate()) FOR [created];

