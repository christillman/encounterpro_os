ALTER TABLE [dbo].[p_Patient_Alias]
    ADD CONSTRAINT [DF_p_Patient_Alias_id] DEFAULT (newid()) FOR [id];

