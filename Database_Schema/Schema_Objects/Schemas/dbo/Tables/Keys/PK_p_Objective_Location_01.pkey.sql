ALTER TABLE [dbo].[p_Objective_Location]
    ADD CONSTRAINT [PK_p_Objective_Location_01] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [treatment_id] ASC, [observation_id] ASC, [observation_location_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

