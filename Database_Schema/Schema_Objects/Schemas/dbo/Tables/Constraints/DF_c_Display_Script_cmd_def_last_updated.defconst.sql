ALTER TABLE [dbo].[c_Display_Command_Definition]
    ADD CONSTRAINT [DF_c_Display_Script_cmd_def_last_updated] DEFAULT (getdate()) FOR [last_updated];

