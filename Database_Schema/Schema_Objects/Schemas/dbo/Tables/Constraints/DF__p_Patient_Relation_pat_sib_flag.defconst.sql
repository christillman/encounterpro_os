ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_pat_sib_flag] DEFAULT ('N') FOR [paternal_sibling_flag];

