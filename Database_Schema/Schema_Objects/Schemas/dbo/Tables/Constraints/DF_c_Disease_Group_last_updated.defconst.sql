ALTER TABLE [dbo].[c_Disease_Group]
    ADD CONSTRAINT [DF_c_Disease_Group_last_updated] DEFAULT (getdate()) FOR [last_updated];

