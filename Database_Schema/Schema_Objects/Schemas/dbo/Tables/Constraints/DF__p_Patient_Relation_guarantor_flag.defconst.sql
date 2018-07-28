ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_guarantor_flag] DEFAULT ('N') FOR [guarantor_flag];

