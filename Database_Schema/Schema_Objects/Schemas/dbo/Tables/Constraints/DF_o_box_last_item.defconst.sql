ALTER TABLE [dbo].[o_box]
    ADD CONSTRAINT [DF_o_box_last_item] DEFAULT ((0)) FOR [last_item];

