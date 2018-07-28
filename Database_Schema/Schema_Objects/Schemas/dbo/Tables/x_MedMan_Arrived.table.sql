CREATE TABLE [dbo].[x_MedMan_Arrived] (
    [billing_id]            VARCHAR (24) NOT NULL,
    [encounter_billing_id]  INT          NULL,
    [message_id]            INT          NOT NULL,
    [appointment_reason]    VARCHAR (50) NULL,
    [encounter_type]        VARCHAR (24) NOT NULL,
    [encounter_description] VARCHAR (80) NULL,
    [primary_provider_id]   VARCHAR (24) NOT NULL,
    [chief_complaint]       VARCHAR (70) NULL,
    [comment2]              VARCHAR (70) NULL,
    [cpr_id]                VARCHAR (12) NOT NULL,
    [encounter_date_time]   DATETIME     NOT NULL,
    [status]                VARCHAR (40) NOT NULL,
    [facilityid]            VARCHAR (24) NULL,
    [encounter_id]          INT          NULL,
    [encounter]             VARCHAR (24) NULL,
    [new_flag]              VARCHAR (4)  NULL,
    [appointment_time]      DATETIME     NULL
);



