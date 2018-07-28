CREATE TABLE [dbo].[o_Message_Log] (
    [message_id]           INT              IDENTITY (1, 1) NOT NULL,
    [subscription_id]      INT              NOT NULL,
    [cpr_id]               VARCHAR (12)     NULL,
    [encounter_id]         INT              NULL,
    [message_type]         VARCHAR (24)     NOT NULL,
    [message_size]         INT              NULL,
    [status]               VARCHAR (12)     NULL,
    [tries]                SMALLINT         NULL,
    [message_date_time]    DATETIME         NULL,
    [message]              IMAGE            NULL,
    [direction]            CHAR (1)         NULL,
    [message_ack_datetime] DATETIME         NULL,
    [comments]             VARCHAR (255)    NULL,
    [id]                   UNIQUEIDENTIFIER NULL,
    [batch_mode]           CHAR (1)         NULL
);



