ALTER TABLE [dbo].[c_component_interface_route]
    ADD CONSTRAINT [DF_route_id] DEFAULT (newid()) FOR [id];

