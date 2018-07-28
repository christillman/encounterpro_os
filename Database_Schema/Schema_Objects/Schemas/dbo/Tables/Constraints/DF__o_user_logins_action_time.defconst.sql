ALTER TABLE [dbo].[o_User_Logins]
    ADD CONSTRAINT [DF__o_user_logins_action_time] DEFAULT (getdate()) FOR [action_time];

