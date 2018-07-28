CREATE TABLE [dbo].[p_Treatment_Item] (
    [cpr_id]                        VARCHAR (12)     NOT NULL,
    [treatment_id]                  INT              IDENTITY (1, 1) NOT NULL,
    [open_encounter_id]             INT              NOT NULL,
    [treatment_type]                VARCHAR (24)     NULL,
    [package_id]                    VARCHAR (24)     NULL,
    [specialty_id]                  VARCHAR (24)     NULL,
    [procedure_id]                  VARCHAR (24)     NULL,
    [drug_id]                       VARCHAR (24)     NULL,
    [material_id]                   INT              NULL,
    [observation_id]                VARCHAR (24)     NULL,
    [treatment_mode]                VARCHAR (24)     NULL,
    [begin_date]                    DATETIME         NULL,
    [administration_sequence]       SMALLINT         NULL,
    [dose_amount]                   REAL             NULL,
    [dose_unit]                     VARCHAR (12)     NULL,
    [administer_frequency]          VARCHAR (12)     NULL,
    [duration_amount]               REAL             NULL,
    [duration_unit]                 VARCHAR (16)     NULL,
    [duration_prn]                  VARCHAR (32)     NULL,
    [dispense_amount]               REAL             NULL,
    [office_dispense_amount]        REAL             NULL,
    [dispense_unit]                 VARCHAR (12)     NULL,
    [brand_name_required]           VARCHAR (1)      NULL,
    [refills]                       SMALLINT         NULL,
    [treatment_description]         VARCHAR (80)     NULL,
    [treatment_goal]                VARCHAR (80)     NULL,
    [location]                      VARCHAR (24)     NULL,
    [maker_id]                      VARCHAR (24)     NULL,
    [lot_number]                    VARCHAR (24)     NULL,
    [expiration_date]               DATETIME         NULL,
    [send_out_flag]                 CHAR (1)         NULL,
    [attachment_id]                 INT              NULL,
    [original_treatment_id]         INT              NULL,
    [parent_treatment_id]           INT              NULL,
    [attach_flag]                   VARCHAR (1)      NULL,
    [referral_question]             VARCHAR (12)     NULL,
    [referral_question_assmnt_id]   VARCHAR (24)     NULL,
    [ordered_by]                    VARCHAR (24)     NULL,
    [signature_attachment_sequence] SMALLINT         NULL,
    [office_id]                     VARCHAR (4)      NULL,
    [risk_level]                    INT              NULL,
    [treatment_sequence]            SMALLINT         NULL,
    [treatment_status]              VARCHAR (12)     NULL,
    [end_date]                      DATETIME         NULL,
    [close_encounter_id]            INT              NULL,
    [created]                       DATETIME         NULL,
    [created_by]                    VARCHAR (24)     NULL,
    [id]                            UNIQUEIDENTIFIER NOT NULL,
    [default_grant]                 BIT              NOT NULL,
    [vial_type]                     VARCHAR (24)     NULL,
    [completed_by]                  VARCHAR (24)     NULL,
    [open_flag]                     CHAR (1)         NOT NULL,
    [specimen_id]                   VARCHAR (40)     NULL,
    [bill_procedure]                BIT              NOT NULL,
    [bill_observation_collect]      BIT              NOT NULL,
    [bill_observation_perform]      BIT              NOT NULL,
    [bill_children_collect]         BIT              NOT NULL,
    [bill_children_perform]         BIT              NOT NULL,
    [ordered_by_supervisor]         VARCHAR (24)     NULL,
    [appointment_date_time]         DATETIME         NULL,
    [ordered_for]                   VARCHAR (24)     NULL,
    [key_field]                     CHAR (1)         NULL,
    [treatment_key]                 VARCHAR (40)     NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Treatment_Item', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Treatment_Item', @level2type = N'COLUMN', @level2name = N'risk_level';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'p_Treatment_Item', @level2type = N'COLUMN', @level2name = N'risk_level';

