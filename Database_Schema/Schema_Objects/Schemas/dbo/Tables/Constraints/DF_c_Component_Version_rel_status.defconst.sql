ALTER TABLE [dbo].[c_Component_Version]
    ADD CONSTRAINT [DF_c_Component_Version_rel_status] DEFAULT ('Production') FOR [release_status];

