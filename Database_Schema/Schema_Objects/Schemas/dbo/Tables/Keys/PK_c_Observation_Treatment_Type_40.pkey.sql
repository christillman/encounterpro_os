ALTER TABLE [dbo].[c_Observation_Treatment_Type]
    ADD CONSTRAINT [PK_c_Observation_Treatment_Type_40] PRIMARY KEY CLUSTERED ([observation_id] ASC, [treatment_type] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

