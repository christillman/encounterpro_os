ALTER TABLE [dbo].[c_Patient_material]
    ADD CONSTRAINT [DF_c_Patient__status_1__14] DEFAULT ('OK') FOR [status];

