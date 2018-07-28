ALTER TABLE [dbo].[c_Consultant]
    ADD CONSTRAINT [DF_c_Consultant_id] DEFAULT (newid()) FOR [id];

