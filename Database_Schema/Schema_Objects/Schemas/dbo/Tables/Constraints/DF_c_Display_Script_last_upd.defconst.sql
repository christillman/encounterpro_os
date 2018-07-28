ALTER TABLE [dbo].[c_Display_Script]
    ADD CONSTRAINT [DF_c_Display_Script_last_upd] DEFAULT (getdate()) FOR [last_updated];

