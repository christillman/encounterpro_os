CREATE TABLE [dbo].[x_encounterpro_Arrived] (
    [billing_id]            VARCHAR (24) NOT NULL,
    [encounter_billing_id]  INT          NOT NULL,
    [message_id]            VARCHAR (60) NOT NULL,
    [appointment_reason]    VARCHAR (50) NULL,
    [encounter_type]        VARCHAR (24) NOT NULL,
    [encounter_description] VARCHAR (80) NULL,
    [primary_provider_id]   VARCHAR (24) NOT NULL,
    [chief_complaint]       VARCHAR (70) NULL,
    [cpr_id]                VARCHAR (12) NOT NULL,
    [encounter_date_time]   DATETIME     NOT NULL,
    [status]                VARCHAR (40) NOT NULL,
    [patient_class]         VARCHAR (40) NULL,
    [facility_namespaceid]  VARCHAR (40) NULL,
    [visitnumber_id]        VARCHAR (40) NULL,
    [alternatevisitid_id]   VARCHAR (40) NULL,
    [encounter_id]          INT          NULL,
    [internal_id]           VARCHAR (40) NULL,
    [external_id]           VARCHAR (40) NULL,
    [Destination]           VARCHAR (80) NULL,
    [new_flag]              VARCHAR (4)  NULL,
    [appointment_time]      DATETIME     NULL,
    [office_id]             VARCHAR (4)  NULL
);



