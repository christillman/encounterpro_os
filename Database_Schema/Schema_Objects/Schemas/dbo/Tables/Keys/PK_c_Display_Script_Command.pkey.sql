ALTER TABLE [dbo].[c_Display_Script_Command]
    ADD CONSTRAINT [PK_c_Display_Script_Command] PRIMARY KEY CLUSTERED ([display_script_id] ASC, [display_command_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

