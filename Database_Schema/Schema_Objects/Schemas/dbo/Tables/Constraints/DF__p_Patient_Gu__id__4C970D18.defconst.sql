ALTER TABLE [dbo].[p_Patient_Guarantor]
    ADD CONSTRAINT [DF__p_Patient_Gu__id__4C970D18] DEFAULT (newid()) FOR [id];

