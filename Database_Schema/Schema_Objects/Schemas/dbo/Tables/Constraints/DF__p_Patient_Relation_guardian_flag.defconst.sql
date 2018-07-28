ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_guardian_flag] DEFAULT ('N') FOR [guardian_flag];

