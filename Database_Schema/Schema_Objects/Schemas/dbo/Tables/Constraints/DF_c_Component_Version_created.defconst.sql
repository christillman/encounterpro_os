ALTER TABLE [dbo].[c_Component_Version]
    ADD CONSTRAINT [DF_c_Component_Version_created] DEFAULT (getdate()) FOR [created];

