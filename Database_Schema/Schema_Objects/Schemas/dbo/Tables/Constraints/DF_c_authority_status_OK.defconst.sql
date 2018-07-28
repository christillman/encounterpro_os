ALTER TABLE [dbo].[c_Authority]
    ADD CONSTRAINT [DF_c_authority_status_OK] DEFAULT ('OK') FOR [status];

