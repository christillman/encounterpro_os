ALTER TABLE [dbo].[c_component_interface_route_property]
    ADD CONSTRAINT [DF_rpty_id] DEFAULT (newid()) FOR [id];

