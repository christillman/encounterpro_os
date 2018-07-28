CREATE TABLE [dbo].[o_Message_Subscription] (
    [subscription_id]        INT           NOT NULL,
    [message_type]           VARCHAR (24)  NOT NULL,
    [office_id]              VARCHAR (4)   NULL,
    [transport_component_id] VARCHAR (24)  NULL,
    [address]                VARCHAR (255) NULL,
    [direction]              CHAR (1)      NULL,
    [compression_type]       VARCHAR (12)  NULL,
    [stream_id]              VARCHAR (24)  NULL
);



