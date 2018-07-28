ALTER TABLE [dbo].[c_Observation]
    ADD CONSTRAINT [DF_c_Observat_composite] DEFAULT ('N') FOR [composite_flag];

