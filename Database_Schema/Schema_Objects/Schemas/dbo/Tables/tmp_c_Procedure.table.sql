CREATE TABLE [dbo].[tmp_c_Procedure] (
    [procedure_id]          VARCHAR (24)     NOT NULL,
    [procedure_type]        VARCHAR (12)     NOT NULL,
    [procedure_category_id] VARCHAR (24)     NULL,
    [description]           VARCHAR (80)     NULL,
    [long_description]      TEXT             NULL,
    [service]               VARCHAR (24)     NULL,
    [cpt_code]              VARCHAR (24)     NULL,
    [modifier]              VARCHAR (2)      NULL,
    [other_modifiers]       VARCHAR (12)     NULL,
    [units]                 FLOAT            NULL,
    [charge]                MONEY            NULL,
    [billing_code]          INT              NULL,
    [billing_id]            VARCHAR (24)     NULL,
    [status]                VARCHAR (12)     NULL,
    [vaccine_id]            VARCHAR (24)     NULL,
    [default_location]      VARCHAR (24)     NULL,
    [default_bill_flag]     CHAR (1)         NULL,
    [location_domain]       VARCHAR (24)     NULL,
    [risk_level]            INT              NULL,
    [complexity]            INT              NULL,
    [id]                    UNIQUEIDENTIFIER NOT NULL,
    [destination_exists]    VARCHAR (1)      NULL,
    [procedure_id_update]   VARCHAR (24)     NOT NULL
);



