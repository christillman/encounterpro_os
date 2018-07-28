ALTER TABLE [dbo].[p_Patient_Encounter]
    ADD CONSTRAINT [DF__p_Patient_En__id__2E26C93A] DEFAULT (newid()) FOR [id];

