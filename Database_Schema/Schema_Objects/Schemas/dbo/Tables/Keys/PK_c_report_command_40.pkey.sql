ALTER TABLE [dbo].[c_Display_Command_Definition]
    ADD CONSTRAINT [PK_c_report_command_40] PRIMARY KEY CLUSTERED ([script_type] ASC, [context_object] ASC, [display_command] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

