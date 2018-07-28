ALTER TABLE [dbo].[o_Component_Selection]
    ADD CONSTRAINT [DF_o_Component_Selection_id] DEFAULT (newid()) FOR [id];

