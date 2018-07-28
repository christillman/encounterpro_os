ALTER TABLE [dbo].[o_User_Privilege]
    ADD CONSTRAINT [DF__o_User_Pr__creat__36870511] DEFAULT (getdate()) FOR [created];

