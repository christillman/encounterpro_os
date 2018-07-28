ALTER TABLE [dbo].[p_Treatment_Item]
    ADD CONSTRAINT [DF__p_treatment_bill_chld_perform] DEFAULT ((0)) FOR [bill_children_perform];

