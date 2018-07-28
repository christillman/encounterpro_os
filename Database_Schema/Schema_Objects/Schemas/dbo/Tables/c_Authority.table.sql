CREATE TABLE [dbo].[c_Authority] (
    [authority_id]              VARCHAR (24)     NOT NULL,
    [authority_type]            VARCHAR (24)     NULL,
    [authority_category]        VARCHAR (24)     NULL,
    [name]                      VARCHAR (50)     NULL,
    [coding_component_id]       VARCHAR (24)     NULL,
    [status]                    VARCHAR (8)      NULL,
    [id]                        UNIQUEIDENTIFIER NOT NULL,
    [authority_address_line_1]  VARCHAR (40)     NULL,
    [authority_address_line_2]  VARCHAR (40)     NULL,
    [authority_city]            VARCHAR (40)     NULL,
    [authority_state]           VARCHAR (2)      NULL,
    [authority_zip]             VARCHAR (12)     NULL,
    [authority_country]         VARCHAR (20)     NULL,
    [authority_phone_number]    VARCHAR (16)     NULL,
    [bill_procedure_assessment] CHAR (1)         NULL
);

