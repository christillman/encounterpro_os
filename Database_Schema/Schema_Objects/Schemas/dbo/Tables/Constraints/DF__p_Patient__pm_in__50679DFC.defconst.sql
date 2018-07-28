ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF__p_Patient__pm_in__50679DFC] DEFAULT ('') FOR [pm_insureds_id];

