ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_payor_flag] DEFAULT ('N') FOR [payor_flag];

