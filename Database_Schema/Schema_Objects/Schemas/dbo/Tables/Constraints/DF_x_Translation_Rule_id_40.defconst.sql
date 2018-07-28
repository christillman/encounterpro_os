ALTER TABLE [dbo].[x_Translation_Rule]
    ADD CONSTRAINT [DF_x_Translation_Rule_id_40] DEFAULT (newid()) FOR [id];

