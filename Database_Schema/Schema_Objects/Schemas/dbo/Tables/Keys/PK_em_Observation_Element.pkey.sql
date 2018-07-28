ALTER TABLE [dbo].[em_Observation_Element]
    ADD CONSTRAINT [PK_em_Observation_Element] PRIMARY KEY CLUSTERED ([em_component] ASC, [em_type] ASC, [em_category] ASC, [em_element] ASC, [observation_id] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

