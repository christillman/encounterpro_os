CREATE TABLE [dbo].[p_Encounter_Charge] (
    [cpr_id]               VARCHAR (12)     NOT NULL,
    [encounter_id]         INT              NOT NULL,
    [encounter_charge_id]  INT              IDENTITY (1, 1) NOT NULL,
    [treatment_id]         INT              NULL,
    [treatment_billing_id] INT              NULL,
    [procedure_type]       VARCHAR (12)     NOT NULL,
    [procedure_id]         VARCHAR (24)     NOT NULL,
    [charge]               MONEY            NULL,
    [bill_flag]            CHAR (1)         NOT NULL,
    [created]              DATETIME         NULL,
    [created_by]           VARCHAR (24)     NULL,
    [id]                   UNIQUEIDENTIFIER NOT NULL,
    [cpt_code]             VARCHAR (24)     NULL,
    [units]                INT              NULL,
    [posted]               CHAR (1)         NOT NULL,
    [modifier]             VARCHAR (2)      NULL,
    [other_modifiers]      VARCHAR (12)     NULL,
    [last_updated]         DATETIME         NULL,
    [last_updated_by]      VARCHAR (24)     NULL,
    [units_recovered]      INT              NULL,
    [charge_recovered]     MONEY            NULL,
    [sort_sequence]        INT              NULL,
    [units_billed]         INT              NULL,
    [charge_billed]        MONEY            NULL
);



