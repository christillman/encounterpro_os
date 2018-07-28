ALTER TABLE [dbo].[c_Report_Definition]
    ADD CONSTRAINT [DF_c_Report_Definition_report_id] DEFAULT (newid()) FOR [report_id];

