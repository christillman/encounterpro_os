﻿CREATE TABLE [dbo].[p_Patient_WP_Item_Archive] (
    [patient_workplan_id]                 INT              NOT NULL,
    [patient_workplan_item_id]            INT              NOT NULL,
    [cpr_id]                              VARCHAR (12)     NULL,
    [encounter_id]                        INT              NULL,
    [treatment_id]                        INT              NULL,
    [workplan_id]                         INT              NOT NULL,
    [item_number]                         INT              NULL,
    [step_number]                         SMALLINT         NULL,
    [item_type]                           VARCHAR (12)     NOT NULL,
    [ordered_service]                     VARCHAR (24)     NULL,
    [active_service_flag]                 CHAR (1)         NOT NULL,
    [in_office_flag]                      CHAR (1)         NULL,
    [ordered_treatment_type]              VARCHAR (24)     NULL,
    [ordered_workplan_id]                 INT              NULL,
    [followup_workplan_id]                INT              NULL,
    [description]                         VARCHAR (80)     NULL,
    [ordered_by]                          VARCHAR (24)     NOT NULL,
    [ordered_for]                         VARCHAR (24)     NULL,
    [priority]                            SMALLINT         NULL,
    [step_flag]                           CHAR (1)         NULL,
    [auto_perform_flag]                   CHAR (1)         NULL,
    [cancel_workplan_flag]                CHAR (1)         NULL,
    [dispatch_date]                       DATETIME         NULL,
    [dispatch_method]                     VARCHAR (24)     NULL,
    [consolidate_flag]                    CHAR (1)         NULL,
    [owner_flag]                          CHAR (1)         NULL,
    [runtime_configured_flag]             CHAR (1)         NULL,
    [observation_tag]                     VARCHAR (12)     NULL,
    [dispatched_patient_workplan_item_id] INT              NULL,
    [owned_by]                            VARCHAR (24)     NULL,
    [begin_date]                          DATETIME         NULL,
    [end_date]                            DATETIME         NULL,
    [escalation_date]                     DATETIME         NULL,
    [expiration_date]                     DATETIME         NULL,
    [completed_by]                        VARCHAR (24)     NULL,
    [room_id]                             VARCHAR (12)     NULL,
    [status]                              VARCHAR (12)     NULL,
    [retries]                             SMALLINT         NULL,
    [folder]                              VARCHAR (40)     NULL,
    [created_by]                          VARCHAR (24)     NOT NULL,
    [created]                             DATETIME         NULL,
    [id]                                  UNIQUEIDENTIFIER NOT NULL
) ON [Workflow];


