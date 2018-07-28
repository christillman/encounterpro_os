ALTER TABLE [dbo].[p_Treatment_Progress]
    ADD CONSTRAINT [PK_p_Treatment_Progress_1__11] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [treatment_id] ASC, [treatment_progress_sequence] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

