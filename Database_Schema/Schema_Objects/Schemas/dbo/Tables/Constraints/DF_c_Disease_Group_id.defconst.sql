ALTER TABLE [dbo].[c_Disease_Group]
    ADD CONSTRAINT [DF_c_Disease_Group_id] DEFAULT (newid()) FOR [id];

