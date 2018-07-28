ALTER TABLE [dbo].[p_Patient_Authority]
    ADD CONSTRAINT [DF_p_pat_auth_status] DEFAULT ('OK') FOR [status];

