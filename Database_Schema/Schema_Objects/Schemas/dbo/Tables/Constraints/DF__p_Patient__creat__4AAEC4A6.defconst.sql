ALTER TABLE [dbo].[p_Patient_Guarantor]
    ADD CONSTRAINT [DF__p_Patient__creat__4AAEC4A6] DEFAULT (getdate()) FOR [created];

