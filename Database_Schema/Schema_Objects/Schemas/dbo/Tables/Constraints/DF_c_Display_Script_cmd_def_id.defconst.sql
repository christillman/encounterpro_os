ALTER TABLE [dbo].[c_Display_Command_Definition]
    ADD CONSTRAINT [DF_c_Display_Script_cmd_def_id] DEFAULT (newid()) FOR [id];

