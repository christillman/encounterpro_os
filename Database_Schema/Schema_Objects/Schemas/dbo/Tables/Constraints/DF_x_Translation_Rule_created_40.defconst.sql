ALTER TABLE [dbo].[x_Translation_Rule]
    ADD CONSTRAINT [DF_x_Translation_Rule_created_40] DEFAULT (getdate()) FOR [created];

