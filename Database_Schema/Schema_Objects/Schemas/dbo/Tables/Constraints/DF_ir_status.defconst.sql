ALTER TABLE [dbo].[c_component_interface_route]
    ADD CONSTRAINT [DF_ir_status] DEFAULT ('NA') FOR [status];

