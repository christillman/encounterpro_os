ALTER TABLE [dbo].[u_Display_Script_Selection]
    ADD CONSTRAINT [DF__u_Display__last___6645C935] DEFAULT (getdate()) FOR [last_updated];

