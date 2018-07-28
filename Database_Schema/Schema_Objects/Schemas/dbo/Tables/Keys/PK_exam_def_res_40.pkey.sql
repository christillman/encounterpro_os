ALTER TABLE [dbo].[u_Exam_Default_Results]
    ADD CONSTRAINT [PK_exam_def_res_40] PRIMARY KEY CLUSTERED ([exam_sequence] ASC, [branch_id] ASC, [result_sequence] ASC, [location] ASC, [user_id] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

