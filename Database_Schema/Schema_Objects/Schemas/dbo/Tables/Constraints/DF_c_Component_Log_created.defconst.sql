ALTER TABLE [dbo].[c_Component_Log]
    ADD CONSTRAINT [DF_c_Component_Log_created] DEFAULT (getdate()) FOR [created];

