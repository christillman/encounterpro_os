ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_mat_sib_flag] DEFAULT ('N') FOR [maternal_sibling_flag];

