ALTER TABLE [dbo].[c_Component_Log]
    ADD CONSTRAINT [DF_c_Component_Log_id] DEFAULT (newid()) FOR [id];

