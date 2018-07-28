ALTER TABLE [dbo].[c_Qualifier_Domain]
    ADD CONSTRAINT [DF_qd_exclusive_27] DEFAULT ('N') FOR [exclusive_flag];

