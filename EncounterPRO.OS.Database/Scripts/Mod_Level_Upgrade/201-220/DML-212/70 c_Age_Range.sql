
-- existing duplicates
DELETE FROM [c_Age_Range]
WHERE [age_range_id] IN ('250','272','306')

-- missing s
UPDATE [c_Age_Range]
SET [description] = '12 Months - 15 Months'
WHERE [age_range_id] = 241


UPDATE [c_Disease] SET [description] = 'Tetanus (7 years and older)'
WHERE [disease_id] = 457
UPDATE [c_Disease] SET [description] = 'Polio (IPV)'
WHERE [disease_id] = 6

DELETE FROM [c_Disease]
WHERE [disease_id] = 16

INSERT INTO [c_Disease] (
	[disease_id]
	,[description]
      ,[display_flag]
      ,[no_vaccine_after_disease]
      ,[sort_sequence]
      ,[status]
	  )
SELECT 16, 'Polio (OPV)'
      ,[display_flag]
      ,[no_vaccine_after_disease]
      ,[sort_sequence]
      ,[status]
FROM [dbo].[c_Disease]
WHERE [disease_id] = 16

DELETE FROM [c_Age_Range]
WHERE [age_range_id] BETWEEN 300 AND 314

SET IDENTITY_INSERT [c_Age_Range] ON
INSERT INTO [c_Age_Range] ( 
	[age_range_id]
      ,[age_range_category]
      ,[description]
      ,[age_from]
      ,[age_from_unit]
      ,[age_to]
      ,[age_to_unit]
      ,[sort_sequence]
      ,[status]
	  )
	  VALUES 
(300, 'Immunization', '0 Months - 59 Months', 0, 'MONTH', 59, 'MONTH', 0, 'OK'), 
(301, 'Immunization', '0 weeks - 2 weeks', 0, 'WEEK', 2, 'WEEK', 0, 'OK'), 
(302, 'Immunization', '10 Weeks - 1 Year', 10, 'WEEK', 1, 'YEAR', 0, 'OK'), 
(303, 'Immunization', '10 Weeks - 32 Weeks', 10, 'WEEK', 32, 'WEEK', 0, 'OK'), 
(304, 'Immunization', '10 weeks - 5 Years', 10, 'WEEK', 5, 'YEAR', 0, 'OK'), 
(305, 'Immunization', '12 Months - 13 Years', 12, 'MONTH', 13, 'YEAR', 0, 'OK'), 
(307, 'Immunization', '12 weeks - 59 Months', 12, 'WEEK', 59, 'MONTH', 0, 'OK'), 
(308, 'Immunization', '14 Weeks - 32 Weeks', 14, 'WEEK', 32, 'WEEK', 0, 'OK'), 
(309, 'Immunization', '14 weeks - 5 Years', 14, 'WEEK', 5, 'YEAR', 0, 'OK'), 
(310, 'Immunization', '18 Months - 5 Years', 18, 'MONTH', 5, 'YEAR', 0, 'OK'), 
(311, 'Immunization', '6 Weeks - 1 Year', 6, 'WEEK', 1, 'YEAR', 0, 'OK'), 
(312, 'Immunization', '6 Weeks - 12 Weeks', 6, 'WEEK', 12, 'WEEK', 0, 'OK'), 
(313, 'Immunization', '6 weeks - 5 Years', 6, 'WEEK', 5, 'YEAR', 0, 'OK'), 
(314, 'Immunization', '9 Months - 5 Years', 9, 'MONTH', 5, 'YEAR', 0, 'OK')

SET IDENTITY_INSERT [c_Age_Range] OFF
