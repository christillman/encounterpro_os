ALTER TABLE [dbo].[c_component_interface_route]
    ADD CONSTRAINT [PK_c_component_interface_route] PRIMARY KEY CLUSTERED ([subscriber_owner_id] ASC, [interfaceserviceid] ASC, [transportsequence] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

