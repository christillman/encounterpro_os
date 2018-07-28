ALTER TABLE [dbo].[p_Patient]
    ADD CONSTRAINT [DF_p_Patient_id_40] DEFAULT (newid()) FOR [id];

