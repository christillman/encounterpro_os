ALTER TABLE [dbo].[c_Classification_Set]
    ADD CONSTRAINT [DF_c_Classification_Set_created] DEFAULT (getdate()) FOR [created];

