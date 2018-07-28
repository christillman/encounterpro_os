ALTER TABLE [dbo].[c_Component_Type]
    ADD CONSTRAINT [DF_c_Component_Type_status] DEFAULT ('OK') FOR [status];

