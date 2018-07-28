ALTER TABLE [dbo].[c_Display_Script_Command]
    ADD CONSTRAINT [DF_c_Display_Script_Command_status] DEFAULT ('OK') FOR [status];

