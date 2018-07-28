ALTER TABLE [dbo].[c_Component_Interface]
    ADD CONSTRAINT [DF_c_Component_Interface_last_updated] DEFAULT (getdate()) FOR [last_updated];

