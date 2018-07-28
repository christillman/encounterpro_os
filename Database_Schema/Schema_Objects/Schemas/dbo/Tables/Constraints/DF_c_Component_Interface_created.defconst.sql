ALTER TABLE [dbo].[c_Component_Interface]
    ADD CONSTRAINT [DF_c_Component_Interface_created] DEFAULT (getdate()) FOR [created];

