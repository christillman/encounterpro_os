ALTER TABLE [dbo].[c_Property]
    ADD CONSTRAINT [DF_c_Property_id] DEFAULT (newid()) FOR [id];

