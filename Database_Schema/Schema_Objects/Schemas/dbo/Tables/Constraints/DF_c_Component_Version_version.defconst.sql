ALTER TABLE [dbo].[c_Component_Version]
    ADD CONSTRAINT [DF_c_Component_Version_version] DEFAULT ((1)) FOR [version];

