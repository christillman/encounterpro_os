ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF__p_Patient_Au__id__2D32A501] DEFAULT (newid()) FOR [id];

