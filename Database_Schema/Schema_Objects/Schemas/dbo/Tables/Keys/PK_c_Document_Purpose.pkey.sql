﻿ALTER TABLE [dbo].[c_Document_Purpose]
    ADD CONSTRAINT [PK_c_Document_Purpose] PRIMARY KEY CLUSTERED ([purpose] ASC) WITH (FILLFACTOR = 70, ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
