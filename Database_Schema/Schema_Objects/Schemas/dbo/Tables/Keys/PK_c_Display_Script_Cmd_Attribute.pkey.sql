ALTER TABLE [dbo].[c_Display_Script_Cmd_Attribute]
    ADD CONSTRAINT [PK_c_Display_Script_Cmd_Attribute] PRIMARY KEY CLUSTERED ([display_script_id] ASC, [display_command_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

