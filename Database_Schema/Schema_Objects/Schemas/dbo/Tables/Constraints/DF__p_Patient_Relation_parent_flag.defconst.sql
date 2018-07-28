ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_parent_flag] DEFAULT ('N') FOR [parent_flag];

