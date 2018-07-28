ALTER TABLE [dbo].[c_Drug_Definition]
    ADD CONSTRAINT [DF_c_Drug_Definition_drug_type] DEFAULT ('Single Drug') FOR [drug_type];

