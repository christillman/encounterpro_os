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
	/* CT: This was commented out before open sourcing, showing that 
		c_Package was added after c_Drug_Administration?
		or just that it was unimportant for documentation */
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
