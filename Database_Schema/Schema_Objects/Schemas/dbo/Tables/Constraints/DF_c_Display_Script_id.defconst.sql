ALTER TABLE [dbo].[c_Display_Script]
    ADD CONSTRAINT [DF_c_Display_Script_id] DEFAULT (newid()) FOR [id];

