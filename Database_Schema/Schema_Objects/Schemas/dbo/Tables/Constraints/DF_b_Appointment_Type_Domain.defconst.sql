ALTER TABLE [dbo].[b_Appointment_Type]
    ADD CONSTRAINT [DF_b_Appointment_Type_Domain] DEFAULT ('JMJBILLINGID') FOR [billing_domain];

