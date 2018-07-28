CREATE NONCLUSTERED INDEX [idx_encounter_date]
    ON [dbo].[p_Patient_Encounter]([encounter_date] ASC, [office_id] ASC, [encounter_id] ASC, [encounter_status] ASC, [patient_location] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0)
    ON [PRIMARY];

