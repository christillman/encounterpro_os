CREATE VIEW v_Patient_Age_Ranges (cpr_id, age_range_id, age_range_category, description) AS
select p_Patient.cpr_id, c_Age_Range.age_range_id, c_Age_Range.age_range_category, c_Age_Range.description
FROM p_Patient, c_Age_Range
WHERE getdate() >= CASE age_from_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_from, p_Patient.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_from, p_Patient.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_from, p_Patient.date_of_birth)
			END
AND (age_to_unit IS NULL
	OR getdate() < CASE age_to_unit
			WHEN 'YEAR' THEN dateadd(year, c_Age_Range.age_to, p_Patient.date_of_birth)
			WHEN 'MONTH' THEN dateadd(month, c_Age_Range.age_to, p_Patient.date_of_birth)
			WHEN 'DAY' THEN dateadd(day, c_Age_Range.age_to, p_Patient.date_of_birth)
			END )
