ALTER TABLE [dbo].[c_Observation]
    ADD CONSTRAINT [DF_c_Observat_status_1__14] DEFAULT ('OK') FOR [status];

