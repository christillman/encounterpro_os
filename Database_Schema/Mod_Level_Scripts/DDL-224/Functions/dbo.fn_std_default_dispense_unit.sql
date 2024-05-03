IF  EXISTS (SELECT * FROM sys.objects 
where object_id = OBJECT_ID(N'fn_std_default_dispense_unit') AND type in (N'FN'))
DROP FUNCTION IF EXISTS dbo.fn_std_default_dispense_unit
GO

CREATE FUNCTION dbo.fn_std_default_dispense_unit (@dosage_form varchar(30), @dose_unit varchar(30))
RETURNS varchar(30) -- default_dispense_unit
AS BEGIN
RETURN 

CASE 
WHEN @dosage_form IN ('Topical Cream', 'Ophthalmic Oint') THEN 'MG'
WHEN @dosage_form = 'Cartridge' THEN 'Cartridge'
WHEN @dosage_form = 'Rectal Ointment' THEN 'TUBE'
WHEN @dosage_form = 'CUTANEOUSSTICK' THEN 'Stick'
WHEN @dosage_form = 'Drops Or' THEN 'DROP'
WHEN @dose_unit LIKE 'Drop%' THEN 'ML'
WHEN @dosage_form IN ('MeterNasalSpray', 'Nasal Spray', 'Nasal Solution') THEN 'Bottle'
WHEN @dosage_form = 'Pen Injector' THEN 'PEN'
WHEN @dosage_form = 'Injectable Foam' THEN 'Canister'
WHEN @dosage_form = 'Metered Inhaler' THEN 'PUFF'

ELSE @dose_unit END

END

GO
GRANT EXECUTE ON [dbo].[fn_std_default_dispense_unit] TO [cprsystem]
GO
