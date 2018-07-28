ALTER TABLE [dbo].[x_Translate_A]
    ADD CONSTRAINT [DF_x_Translate_A_created] DEFAULT (getdate()) FOR [created];

