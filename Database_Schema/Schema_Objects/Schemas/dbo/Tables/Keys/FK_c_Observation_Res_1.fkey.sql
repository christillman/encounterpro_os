ALTER TABLE [dbo].[c_Observation_Result_Set_Item]
    ADD CONSTRAINT [FK_c_Observation_Res_1] FOREIGN KEY ([result_set_id]) REFERENCES [dbo].[c_Observation_Result_Set] ([result_set_id]) ON DELETE NO ACTION ON UPDATE NO ACTION;

