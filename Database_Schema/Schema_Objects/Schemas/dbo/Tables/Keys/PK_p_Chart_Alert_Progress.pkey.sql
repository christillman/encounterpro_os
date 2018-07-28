ALTER TABLE [dbo].[p_Chart_Alert_Progress]
    ADD CONSTRAINT [PK_p_Chart_Alert_Progress] PRIMARY KEY CLUSTERED ([cpr_id] ASC, [alert_id] ASC, [alert_progress_sequence] ASC) WITH (FILLFACTOR = 80, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

