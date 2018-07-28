ALTER TABLE [dbo].[x_Translate_P]
    ADD CONSTRAINT [DF_x_Translate_P_created] DEFAULT (getdate()) FOR [created];

