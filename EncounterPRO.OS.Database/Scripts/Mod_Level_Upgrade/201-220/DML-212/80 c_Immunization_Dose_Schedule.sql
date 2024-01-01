/*
select distinct 
'(300, ''Immunization'', ''' + [c_age_range.description]
+ ''', ' + convert(varchar(2),convert(int,left([c_age_range.description],2)) )
+ ', ''' + case when substring([c_age_range.description],5,1) = 'e' THEN 'WEEK' ELSE 'MONTH' END
+ ''', ' +  convert(varchar(2),convert(int, 
	RTRIM(substring([c_age_range.description],charindex(' - ',[c_age_range.description])+3,2))
	) )
+ ', ''' + case right([c_age_range.description],5) 
	when ' Year' THEN 'YEAR' 
	when 'Weeks' THEN 'WEEK' 
	when 'Years' THEN 'YEAR' 
	ELSE 'MONTH' END + ''', 0, ''OK''), ' 
from [dbo].[08_01_2021_Kenya_US_Immunizationschedule]
where [c_age_range.age_range_id] like 'This%'
*/

DELETE -- select * 
FROM [c_Immunization_Dose_Schedule]
WHERE valid_in = 'ke;'

INSERT INTO [dbo].[c_Immunization_Dose_Schedule] (
	[disease_id]
      ,[dose_number]
      ,[patient_age_range_id]
      ,[first_dose_age_range_id]
      -- ,[last_dose_age_range_id] -- no column in spreadsheet
      ,[last_dose_interval_amount]
      ,[last_dose_interval_unit_id]
      ,[sort_sequence]
      ,[dose_text]
      ,[valid_in]
	  )
	  VALUES 
(10, 1, 314, NULL, NULL, NULL, 0, 'Give 1st dose at 9 months or at first contact with child 9 months and above. If a child has missed the first or second dose, both doses should be administered upto 5 years of age, with an interval of 4 weeks.','ke;'),
(10, 2, 310, NULL, 4, 'Week', 0, 'Give 2nd dose at 18 months or at first contact with child 18 months and above.','ke;'),
(11, 1, 241, NULL, NULL, NULL, 0, 'Give single dose between 12 months and 15 months','ke;'),
(12, 1, 241, NULL, NULL, NULL, 0, 'Give single dose between 12 months and 15 months','ke;'),
(16, 1, 301, NULL, NULL, NULL, 0, 'Give birth dose at birth or at first contact with child up to 2 weeks. Do not give birth dose of oral Polio after two (2 weeks) of age.','ke;'),
(16, 2, 313, NULL, NULL, NULL, 0, 'Give 1st dose OPV at 6 weeks of life or at first contact with child after that age.','ke;'),
(16, 3, 304, NULL, 4, 'Week', 0, 'Give 2nd dose OPV at 10 weeks or at first contact with child after that age and at least  4 weeks after 1st dose of OPV.','ke;'),
(16, 4, 309, NULL, 4, 'Week', 0, 'Give 3rd dose OPV at 14 weeks or at first contact with child after that age and at least 4 weeks after 2nd dose of OPV.','ke;'),
(2, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(2, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(2, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(3, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(3, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(3, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(4, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(4, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(4, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(449, 1, 300, NULL, NULL, NULL, 0, 'Give BCG single dose at birth or at first contact with child up to 59 months of age.','ke;'),
(449, 1, 307, NULL, 12, 'WEEK', 0, 'If patient is less than 59 months and BCG scar is not visible 12 weeks after BCG vaccine is administered, revaccinate once with a similar dose of BCG vaccine.','ke;'),
(450, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(450, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(450, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(455, 1, 311, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks but less than 1 year old.','ke;'),
(455, 1, 312, NULL, NULL, NULL, 0, 'Rotateq ONLY- Give the 1st dose of Rotateq vaccine at 6 weeks of life or at first contact with child older than 6 weeks but less than 12 weeks.','ke;'),
(455, 2, 258, NULL, 4, 'Week', 0, 'Rotateq ONLY- Give the 2nd dose of Rotateq at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(455, 2, 302, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(455, 2, 303, NULL, 4, 'Week', 0, 'Rotateq ONLY- Give the 2nd dose of Rotateq at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(455, 3, 259, NULL, 4, 'Week', 0, 'Rotateq ONLY- Give the 3rd dose Rotateq at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 1st dose. Do not give Rotateq after 32 weeks.','ke;'),
(455, 3, 308, NULL, 4, 'Week', 0, 'Rotateq ONLY- Give the 3rd dose Rotateq at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 1st dose. Do not give Rotateq after 32 weeks.','ke;'),
(5, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(5, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(5, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(8, 1, 313, NULL, NULL, NULL, 0, 'Give the 1st dose at 6 weeks of life or at first contact with child older than 6 weeks.','ke;'),
(8, 2, 304, NULL, 4, 'Week', 0, 'Give the 2nd dose at 10 weeks or at the next contact with child older than 10 weeks and at least 4 weeks after the 1st dose.','ke;'),
(8, 3, 309, NULL, 4, 'Week', 0, 'Give the 3rd dose at 14 weeks or at the next contact with child older than 14 weeks and at least 4 weeks after the 2nd dose.','ke;'),
(9, 1, 252, NULL, NULL, NULL, 0, 'If patient is over 13 years old, then give 2 doses administered 4-8 weeks apart','ke;'),
(9, 1, 305, NULL, NULL, NULL, 0, 'Give single dose to children 12 months old up to 13 years old.','ke;'),
(9, 2, 252, 252, 4, 'Week', 0, 'If the patient is over 13 years old and the 1st dose was given after 13 years of age, then give the 2nd dose at least 4 -8 weeks after the 1st dose.','ke;')
/*
select  
'(' + CASE WHEN [c_Disease.description] = 'Polio (OPV)' THEN '16'
	ELSE [c_immunization_dose_schedule.disease_id] END + ', ' 
+ [c_immunization_dose_schedule.dose_number] + ', ' 
+ CASE WHEN [c_immunization_dose_schedule.patient_age_range_id] LIKE 'Please%' THEN
	(SELECT convert(varchar(3),[age_range_id]) ) 
	ELSE [c_immunization_dose_schedule.patient_age_range_id] END + ', ' 
+ [c_immunization_dose_schedule.first_dose_age_range_id] + ', ' 
+ [c_immunization_dose_schedule.last_dose_interval_amount] + ', ' 
+ CASE WHEN [c_immunization_dose_schedule.last_dose_interval_unit_id] = 'NULL' THEN 'NULL'
	ELSE '''' + [c_immunization_dose_schedule.last_dose_interval_unit_id] + '''' END + ', '
+ '0, ''' + REPLACE([c_immunization_dose_schedule.dose_text],'''''''','''''''') + ''',''ke;''),'
FROM [dbo].[08_01_2021_Kenya_US_Immunizationschedule] s
LEFT JOIN c_Age_Range a ON a.[description] = s.[c_age_range.description]
where valid_in = 'Kenya' 
order by 1
*/
