ALTER TABLE [dbo].[x_Message_Type]
    ADD CONSTRAINT [DF_x_Message_Type_consumer_40] DEFAULT ('N') FOR [handler_component_id];

