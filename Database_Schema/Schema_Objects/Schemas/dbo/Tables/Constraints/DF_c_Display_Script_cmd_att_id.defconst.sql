ALTER TABLE [dbo].[c_Display_Script_Cmd_Attribute]
    ADD CONSTRAINT [DF_c_Display_Script_cmd_att_id] DEFAULT (newid()) FOR [id];

