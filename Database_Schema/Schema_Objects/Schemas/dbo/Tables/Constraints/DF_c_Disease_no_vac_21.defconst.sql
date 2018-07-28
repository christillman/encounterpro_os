ALTER TABLE [dbo].[c_Disease]
    ADD CONSTRAINT [DF_c_Disease_no_vac_21] DEFAULT ('N') FOR [no_vaccine_after_disease];

