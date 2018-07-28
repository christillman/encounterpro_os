ALTER TABLE [dbo].[c_Component_Version]
    ADD CONSTRAINT [DF_c_Component_Version_status] DEFAULT ('CheckedIn') FOR [status];

