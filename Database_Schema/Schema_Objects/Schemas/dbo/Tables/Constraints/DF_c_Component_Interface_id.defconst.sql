ALTER TABLE [dbo].[c_Component_Interface]
    ADD CONSTRAINT [DF_c_Component_Interface_id] DEFAULT (newid()) FOR [id];

