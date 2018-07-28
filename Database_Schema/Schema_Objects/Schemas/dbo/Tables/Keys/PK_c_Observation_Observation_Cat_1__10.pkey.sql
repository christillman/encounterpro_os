ALTER TABLE [dbo].[c_Observation_Observation_Cat]
    ADD CONSTRAINT [PK_c_Observation_Observation_Cat_1__10] PRIMARY KEY CLUSTERED ([treatment_type] ASC, [observation_category_id] ASC, [observation_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

