﻿ALTER TABLE [dbo].[c_Report_Recipient]
    ADD CONSTRAINT [PK_c_Report_Recipient_40] PRIMARY KEY CLUSTERED ([report_id] ASC, [actor_class] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
