ALTER TABLE [dbo].[p_Patient_Relation]
    ADD CONSTRAINT [DF__p_Patient_Relation_status] DEFAULT ('OK') FOR [status];

