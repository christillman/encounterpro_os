ALTER TABLE [dbo].[c_Display_Command_Definition]
    ADD CONSTRAINT [DF_c_Display_Script_cmd_script_type] DEFAULT ('RTF') FOR [script_type];

