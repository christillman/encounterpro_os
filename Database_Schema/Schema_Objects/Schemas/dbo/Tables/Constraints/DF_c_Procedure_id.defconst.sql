ALTER TABLE [dbo].[c_Procedure]
    ADD CONSTRAINT [DF_c_Procedure_id] DEFAULT (newid()) FOR [id];

