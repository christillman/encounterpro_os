ALTER TABLE [dbo].[x_Message_Type]
    ADD CONSTRAINT [DF_x_Message_Type_producer_40] DEFAULT ('N') FOR [creator_component_id];

