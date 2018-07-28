ALTER TABLE [dbo].[o_menu_selection]
    ADD CONSTRAINT [DF__o_Menu_Se__last___6551A4FC] DEFAULT (getdate()) FOR [last_updated];

