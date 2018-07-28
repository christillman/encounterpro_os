CREATE TABLE [dbo].[c_Actor_Communication] (
    [actor_id]               INT              NOT NULL,
    [communication_sequence] INT              IDENTITY (1, 1) NOT NULL,
    [communication_type]     VARCHAR (24)     NOT NULL,
    [communication_value]    VARCHAR (80)     NULL,
    [note]                   VARCHAR (80)     NULL,
    [sort_sequence]          INT              NULL,
    [status]                 VARCHAR (12)     NOT NULL,
    [created]                DATETIME         NOT NULL,
    [created_by]             VARCHAR (24)     NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [communication_name]     VARCHAR (24)     NULL,
    [c_actor_id]             UNIQUEIDENTIFIER NULL
);



