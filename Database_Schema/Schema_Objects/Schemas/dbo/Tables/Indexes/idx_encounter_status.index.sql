CREATE NONCLUSTERED INDEX [idx_encounter_status]
    ON [dbo].[p_Patient_Encounter]([encounter_status] ASC, [office_id] ASC, [cpr_id] ASC, [encounter_id] ASC, [encounter_date] ASC, [billing_posted] ASC, [attending_doctor] ASC, [patient_location] ASC, [patient_workplan_id] ASC, [referring_doctor] ASC, [new_flag] ASC, [encounter_description] ASC, [encounter_type] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];

