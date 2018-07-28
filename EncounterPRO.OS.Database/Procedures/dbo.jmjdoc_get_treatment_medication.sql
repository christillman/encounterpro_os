--EncounterPRO Open Source Project
--
--Copyright 2010-2011 The EncounterPRO Foundation, Inc.
--
--This program is free software: you can redistribute it and/or modify it under the terms of 
--the GNU Affero General Public License as published by the Free Software Foundation, either 
--version 3 of the License, or (at your option) any later version.
--
--This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; 
--without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
--See the GNU Affero General Public License for more details.
--
--You should have received a copy of the GNU Affero General Public License along with this 
--program. If not, see http://www.gnu.org/licenses.
--
--EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero 
--General Public License version 3, or any later version. As such, linking the Project 
--statically or dynamically with other components is making a combined work based on the 
--Project. Thus, the terms and conditions of the GNU Affero General Public License version 3, 
--or any later version, cover the whole combination.
--
--However, as an additional permission, the copyright holders of EncounterPRO Open Source 
--Project give you permission to link the Project with independent components, regardless of 
--the license terms of these independent components, provided that all of the following are true:
--
--1. All access from the independent component to persisted data which resides
--   inside any EncounterPRO Open Source data store (e.g. SQL Server database) 
--   be made through a publically available database driver (e.g. ODBC, SQL 
--   Native Client, etc) or through a service which itself is part of The Project.
--2. The independent component does not create or rely on any code or data 
--   structures within the EncounterPRO Open Source data store unless such 
--   code or data structures, and all code and data structures referred to 
--   by such code or data structures, are themselves part of The Project.
--3. The independent component either a) runs locally on the user's computer,
--   or b) is linked to at runtime by The Project’s Component Manager object 
--   which in turn is called by code which itself is part of The Project.
--
--An independent component is a component which is not derived from or based on the Project.
--If you modify the Project, you may extend this additional permission to your version of 
--the Project, but you are not obligated to do so. If you do not wish to do so, delete this 
--additional permission statement from your version.
--
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_WARNINGS ON
SET NOCOUNT ON
SET XACT_ABORT ON
GO

-- Drop Procedure [dbo].[jmjdoc_get_treatment_medication]
Print 'Drop Procedure [dbo].[jmjdoc_get_treatment_medication]'
GO
IF (EXISTS(SELECT * FROM sys.objects WHERE [object_id] = OBJECT_ID(N'[dbo].[jmjdoc_get_treatment_medication]') AND [type]='P'))
DROP PROCEDURE [dbo].[jmjdoc_get_treatment_medication]
GO

-- Create Procedure [dbo].[jmjdoc_get_treatment_medication]
Print 'Create Procedure [dbo].[jmjdoc_get_treatment_medication]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE jmjdoc_get_treatment_medication (
	@ps_cpr_id varchar(24),
	@pl_treatment_id int
)

AS


SELECT	 t.drug_id as drugid,   
         dDef.common_name as commanname,
         dDef.generic_name as genericname,
--         dBrand.brand_name as brandname,
	t.brand_name_required as brandname,
         t.lot_number as lotnumber,
   	 t.expiration_date as expirationdate,
	 dMaker.maker_name as manufacturer,
	 t.package_id as packageid,
	 dPack.administer_method as packadministermethod,
	 dPack.description as packagedescription,
	 dPack.dose_amount as packagedoseamount,
         dPack.dose_unit as packagedoseunitid,
	 packagedoseunit.description as packagedoseunit,
	 packagedoseunit.unit_type as packagedoseunitamounttype,
	 packagedoseunit.plural_flag as packagedosepluralrule,
	 packagedoseunit.print_unit as packagedoseprintunit,
	 packagedoseunit.display_mask as packagedosedisplaytemplate,
	 packagedoseunit.prefix as packagedoseprefix,
	 packagedoseunit.major_unit_display_suffix as packagedosemajorunitdisplaysuffix,
	 packagedoseunit.minor_unit_display_suffix as packagedoseminorunitdisplaysuffix,
	 packagedoseunit.major_unit_input_suffixes as packagedosemajorunitinputsuffix,
	 packagedoseunit.minor_unit_input_suffixes as packagedoseminorunitinputsuffix,
	 packagedoseunit.multiplier as packagedosemajorminormultiplier,
	 packagedoseunit.display_minor_units as packagedosedisplayminorunits,
	 dPack.administer_per_dose as packageadminperdoseamount,
	 dPack.administer_unit as packageadminperdoseunitid,
	 packageadminunit.description as packageadminperdoseunit,
	 packageadminunit.unit_type as packageadminperdoseunitamounttype,
	 packageadminunit.plural_flag as packageadminperdosepluralrule,
	 packageadminunit.print_unit as packageadminperdoseprintunit,
	 packageadminunit.display_mask as packageadminperdosedisplaytemplate,
	 packageadminunit.prefix as packageadminperdoseprefix,
	 packageadminunit.major_unit_display_suffix as packageadminperdosemajorunitdisplaysuffix,
	 packageadminunit.minor_unit_display_suffix as packageadminperdoseminorunitdisplaysuffix,
	 packageadminunit.major_unit_input_suffixes as packageadminperdosemajorunitinputsuffix,
	 packageadminunit.minor_unit_input_suffixes as packageadminperdoseminorunitinputsuffix,
	 packageadminunit.multiplier as packageadminperdosemajorminormultiplier,
	 packageadminunit.display_minor_units as packageadminperdosedisplayminorunits,
         dPack.dosage_form as pacakgedosageform,
	 t.dose_amount as doseamount,
	 t.dose_unit as doseunitid,
	 doseunit.description as doseunit,
	 doseunit.unit_type as doseunitamounttype,
	 doseunit.plural_flag as dosepluralrule,
	 doseunit.print_unit as doseprintunit,
	 doseunit.display_mask as dosedisplaytemplate,
	 doseunit.prefix as doseprefix,
	 doseunit.major_unit_display_suffix as dosemajorunitdisplaysuffix,
	 doseunit.minor_unit_display_suffix as doseminorunitdisplaysuffix,
	 doseunit.major_unit_input_suffixes as dosemajorunitinputsuffix,
	 doseunit.minor_unit_input_suffixes as doseminorunitinputsuffix,
	 doseunit.multiplier as dosemajorminormultiplier,
	 doseunit.display_minor_units as dosedisplayminorunits,
	 -- missing frequency
	 t.duration_amount as durationamount,
	 t.duration_unit as durationunitid,
	 durationunit.description as durationunit,
	 durationunit.unit_type as durationunitamounttype,
	 durationunit.plural_flag as durationpluralrule,
	 durationunit.print_unit as durationprintunit,
	 durationunit.display_mask as durationdisplaytemplate,
	 durationunit.prefix as durationprefix,
	 durationunit.major_unit_display_suffix as durationmajorunitdisplaysuffix,
	 durationunit.minor_unit_display_suffix as durationminorunitdisplaysuffix,
	 durationunit.major_unit_input_suffixes as durationmajorunitinputsuffix,
	 durationunit.minor_unit_input_suffixes as durationminorunitinputsuffix,
	 durationunit.multiplier as durationmajorminormultiplier,
	 durationunit.display_minor_units as durationdisplayminorunits,
	 t.duration_prn as durationprn,
	 t.dispense_amount as dispenseatpharmacyamount,
	 t.dispense_unit as dispenseatpharmacyunitid,
	 dispenseunit.description as dispenseatpharmacyunit,
	 dispenseunit.unit_type as dispenseatpharmacyunitamounttype,
	 dispenseunit.plural_flag as dispenseatpharmacypluralrule,
	 dispenseunit.print_unit as dispenseatpharmacyprintunit,
	 dispenseunit.display_mask as dispenseatpharmacydisplaytemplate,
	 dispenseunit.prefix as dispenseatpharmacyprefix,
	 dispenseunit.major_unit_display_suffix as dispenseatpharmacymajorunitdisplaysuffix,
	 dispenseunit.minor_unit_display_suffix as dispenseatpharmacyminorunitdisplaysuffix,
	 dispenseunit.major_unit_input_suffixes as dispenseatpharmacymajorunitinputsuffix,
	 dispenseunit.minor_unit_input_suffixes as dispenseatpharmacyminorunitinputsuffix,
	 dispenseunit.multiplier as dispenseatpharmacymajorminormultiplier,
	 dispenseunit.display_minor_units as dispenseatpharmacydisplayminorunits,
	 t.office_dispense_amount as dispenseinofficeamount,
	 t.dispense_unit as dispenseinofficeunitid,
	 dispenseunit.description as dispenseinofficeunit,
	 dispenseunit.unit_type as dispenseinofficeunitamounttype,
	 dispenseunit.plural_flag as dispenseinofficepluralrule,
	 dispenseunit.print_unit as dispenseinofficeprintunit,
	 dispenseunit.display_mask as dispenseinofficedisplaytemplate,
	 dispenseunit.prefix as dispenseinofficeprefix,
	 dispenseunit.major_unit_display_suffix as dispenseinofficemajorunitdisplaysuffix,
	 dispenseunit.minor_unit_display_suffix as dispenseinofficeminorunitdisplaysuffix,
	 dispenseunit.major_unit_input_suffixes as dispenseinofficemajorunitinputsuffix,
	 dispenseunit.minor_unit_input_suffixes as dispenseinofficeminorunitinputsuffix,
	 dispenseunit.multiplier as dispenseinofficemajorminormultiplier,
	 dispenseunit.display_minor_units as dispenseinofficedisplayminorunits,
	CASE WHEN t.brand_name_required IS NULL THEN 'True'
	     WHEN t.brand_name_required = 'N' THEN 'True'
	     ELSE 'False'
	END as brandnamerequired,
	 t.refills as refillsallowed
FROM	p_Treatment_Item t
	LEFT OUTER JOIN c_Drug_Definition dDef
	ON t.drug_id = dDef.drug_id
	--LEFT OUTER JOIN c_Drug_Brand dBrand
	--ON t.drug_id = dBrand.drug_id
	LEFT OUTER JOIN c_Drug_Maker dMaker
	ON t.maker_id = dMaker.maker_id
	--LEFT OUTER JOIN c_Drug_Administration dDrugAdmin
	--ON t.drug_id = dDrugAdmin.drug_id
	--AND t.administration_sequence = dDrugAdmin.administration_sequence
	LEFT OUTER JOIN c_Package dPack
	ON t.package_id = dPack.package_id
	LEFT OUTER JOIN c_Unit packagedoseunit
	ON dPack.dose_unit = packagedoseunit.unit_id
	LEFT OUTER JOIN c_Unit packageadminunit
	ON dPack.administer_unit = packageadminunit.unit_id
	LEFT OUTER JOIN c_Unit doseunit
	ON t.dose_unit = doseunit.unit_id
	LEFT OUTER JOIN c_Unit durationunit
	ON t.duration_unit = durationunit.unit_id
	LEFT OUTER JOIN c_Unit dispenseunit
	ON t.dispense_unit = dispenseunit.unit_id
WHERE t.cpr_id = @ps_cpr_id
AND t.treatment_id = @pl_treatment_id
GO
GRANT EXECUTE
	ON [dbo].[jmjdoc_get_treatment_medication]
	TO [cprsystem]
GO

