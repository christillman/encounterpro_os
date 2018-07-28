ALTER TABLE [dbo].[p_Patient_WP_Item]
    ADD CONSTRAINT [DF_ppwi_active_service_flag_b12] DEFAULT ('N') FOR [active_service_flag];

