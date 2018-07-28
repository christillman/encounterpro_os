ALTER TABLE [dbo].[o_box]
    ADD CONSTRAINT [DF_o_box_box_type] DEFAULT ('LETTERS') FOR [box_type];

