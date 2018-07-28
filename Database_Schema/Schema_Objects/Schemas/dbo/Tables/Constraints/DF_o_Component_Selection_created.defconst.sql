ALTER TABLE [dbo].[o_Component_Selection]
    ADD CONSTRAINT [DF_o_Component_Selection_created] DEFAULT (getdate()) FOR [created];

