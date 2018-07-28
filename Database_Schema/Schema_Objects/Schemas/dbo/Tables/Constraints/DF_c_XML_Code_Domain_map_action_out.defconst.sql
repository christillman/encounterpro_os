ALTER TABLE [dbo].[c_XML_Code_Domain]
    ADD CONSTRAINT [DF_c_XML_Code_Domain_map_action_out] DEFAULT ('Create') FOR [missing_map_action_out];

