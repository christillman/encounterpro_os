CREATE CLUSTERED INDEX [idx_workplan_cluster]
    ON [dbo].[p_Patient_WP]([cpr_id] ASC, [encounter_id] ASC, [treatment_id] ASC, [patient_workplan_id] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, MAXDOP = 0);

