ALTER TABLE [dbo].[c_Treatment_Type_Service_Attribute]
    ADD CONSTRAINT [PK_c_Trt_Type_Service_Attribute] PRIMARY KEY CLUSTERED ([treatment_type] ASC, [service_sequence] ASC, [attribute_sequence] ASC) WITH (FILLFACTOR = 100, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);

