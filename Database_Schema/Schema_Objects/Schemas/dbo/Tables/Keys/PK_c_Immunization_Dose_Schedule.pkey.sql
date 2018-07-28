ALTER TABLE [dbo].[c_Immunization_Dose_Schedule]
    ADD CONSTRAINT [PK_c_Immunization_Dose_Schedule] PRIMARY KEY CLUSTERED ([disease_id] ASC, [dose_schedule_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

