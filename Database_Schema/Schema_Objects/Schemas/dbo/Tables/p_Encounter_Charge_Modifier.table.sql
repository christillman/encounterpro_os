CREATE TABLE [dbo].[p_Encounter_Charge_Modifier] (
    [cpr_id]              VARCHAR (12) NOT NULL,
    [encounter_id]        INT          NOT NULL,
    [encounter_charge_id] INT          NOT NULL,
    [modifier]            VARCHAR (12) NOT NULL,
    [billing_sequence]    SMALLINT     NULL
);



