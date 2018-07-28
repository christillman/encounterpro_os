ALTER TABLE [dbo].[p_Treatment_Item]
    ADD CONSTRAINT [DF__p_treatment_bill_obs_perform] DEFAULT ((1)) FOR [bill_observation_perform];

