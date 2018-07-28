ALTER TABLE [dbo].[p_Observation_Result]
    ADD CONSTRAINT [DF__p_Observatio__id__51A50FA1] DEFAULT (newid()) FOR [id];

