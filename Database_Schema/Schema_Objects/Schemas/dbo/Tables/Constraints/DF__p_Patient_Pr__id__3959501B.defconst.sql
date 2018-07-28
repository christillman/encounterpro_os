ALTER TABLE [dbo].[p_Patient_Progress]
    ADD CONSTRAINT [DF__p_Patient_Pr__id__3959501B] DEFAULT (newid()) FOR [id];

