ALTER TABLE [dbo].[o_User_Logins]
    ADD CONSTRAINT [DF__o_user_logins_action_status] DEFAULT ('Success') FOR [action_status];

