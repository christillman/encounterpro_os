CREATE TABLE [dbo].[b_Appointment_Type] (
    [appointment_type] VARCHAR (50) NOT NULL,
    [appointment_text] VARCHAR (50) NULL,
    [encounter_type]   VARCHAR (24) NOT NULL,
    [new_flag]         CHAR (1)     NOT NULL,
    [billing_domain]   VARCHAR (50) NOT NULL
);




GO
EXECUTE sp_addextendedproperty @name = N'MS_DisplayControl', @value = N'109', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Appointment_Type', @level2type = N'COLUMN', @level2name = N'appointment_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Format', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Appointment_Type', @level2type = N'COLUMN', @level2name = N'appointment_text';


GO
EXECUTE sp_addextendedproperty @name = N'MS_IMEMode', @value = N'0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'b_Appointment_Type', @level2type = N'COLUMN', @level2name = N'appointment_text';

