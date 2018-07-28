CREATE TABLE [dbo].[c_XML_Code_Domain] (
    [owner_id]               INT              NOT NULL,
    [code_domain]            VARCHAR (40)     NOT NULL,
    [description]            VARCHAR (80)     NULL,
    [owner_domain]           VARCHAR (40)     NULL,
    [epro_domain]            VARCHAR (64)     NULL,
    [created]                DATETIME         NOT NULL,
    [created_by]             VARCHAR (24)     NOT NULL,
    [last_updated]           DATETIME         NOT NULL,
    [id]                     UNIQUEIDENTIFIER NOT NULL,
    [status]                 VARCHAR (12)     NOT NULL,
    [code_domain_owner_id]   INT              NOT NULL,
    [missing_map_action_in]  VARCHAR (24)     NOT NULL,
    [missing_map_action_out] VARCHAR (24)     NOT NULL,
    [map_cardinality]        VARCHAR (12)     NOT NULL
);



