ALTER TABLE [dbo].[o_box]
    ADD CONSTRAINT [DF_o_box_box_open_date] DEFAULT (getdate()) FOR [box_open_date];

