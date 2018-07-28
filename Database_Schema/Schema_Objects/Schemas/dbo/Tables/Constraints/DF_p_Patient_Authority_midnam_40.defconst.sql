ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF_p_Patient_Authority_midnam_40] DEFAULT ('') FOR [insureds_middle_name];

