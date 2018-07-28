ALTER TABLE [dbo].[c_Observation]
    ADD CONSTRAINT [DF_c_Observat_exclusive] DEFAULT ('N') FOR [exclusive_flag];

