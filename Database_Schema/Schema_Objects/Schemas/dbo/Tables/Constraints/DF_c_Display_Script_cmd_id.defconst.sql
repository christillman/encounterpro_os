ALTER TABLE [dbo].[c_Display_Script_Command]
    ADD CONSTRAINT [DF_c_Display_Script_cmd_id] DEFAULT (newid()) FOR [id];

