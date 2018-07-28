ALTER TABLE [dbo].[p_Patient_Alias]
    ADD CONSTRAINT [DF_p_Patient_Alias_type] DEFAULT ('Primary') FOR [alias_type];

