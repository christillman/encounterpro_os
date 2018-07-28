ALTER TABLE [dbo].[c_Chart_Section_Page_Attribute]
    ADD CONSTRAINT [PK_chart_sec_page_att_40] PRIMARY KEY CLUSTERED ([chart_id] ASC, [section_id] ASC, [page_id] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

