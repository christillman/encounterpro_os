ALTER TABLE [dbo].[p_assessment_Progress]
    ADD CONSTRAINT [PK_p_assessment_Progress_1__11] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [problem_id] ASC, [assessment_progress_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

