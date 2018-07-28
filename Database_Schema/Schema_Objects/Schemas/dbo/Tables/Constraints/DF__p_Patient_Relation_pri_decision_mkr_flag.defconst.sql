ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_pri_decision_mkr_flag] DEFAULT ('N') FOR [primary_decision_maker_flag];

