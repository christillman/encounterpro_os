ALTER TABLE [dbo].[p_Observation_Location]
    ADD CONSTRAINT [PK_p_Obs_Location_01] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [observation_sequence] ASC, [observation_location_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

