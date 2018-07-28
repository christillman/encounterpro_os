ALTER TABLE [dbo].[o_Treatment_Type_Default_Mode]
    ADD CONSTRAINT [DF__o_Treatme__creat__00EC7074] DEFAULT (getdate()) FOR [created];

