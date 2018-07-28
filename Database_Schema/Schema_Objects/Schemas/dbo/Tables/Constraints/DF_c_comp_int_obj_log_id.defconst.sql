ALTER TABLE [dbo].[c_component_interface_object_log]
    ADD CONSTRAINT [DF_c_comp_int_obj_log_id] DEFAULT (newid()) FOR [id];

