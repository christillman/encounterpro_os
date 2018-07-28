CREATE TABLE [dbo].[c_Assessment_Type] (
    [assessment_type]     VARCHAR (24)     NOT NULL,
    [description]         VARCHAR (80)     NULL,
    [button]              VARCHAR (64)     NULL,
    [icon_open]           VARCHAR (64)     NULL,
    [icon_closed]         VARCHAR (64)     NULL,
    [default_bill_flag]   CHAR (1)         NULL,
    [in_office_flag]      CHAR (1)         NULL,
    [display_format]      VARCHAR (40)     NULL,
    [status]              VARCHAR (12)     NULL,
    [id]                  UNIQUEIDENTIFIER NOT NULL,
    [display_script_id]   INT              NULL,
    [complexity]          INT              NULL,
    [soap_display_rule]   VARCHAR (24)     NOT NULL,
    [well_encounter_flag] CHAR (1)         NULL
);

