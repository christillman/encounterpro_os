-- Title casing redux

UPDATE p_Patient
SET [first_name] = dbo.fn_wordcap([first_name]),
 [last_name] = dbo.fn_wordcap([last_name]),
 [middle_name]= dbo.fn_wordcap([middle_name]),
 [name_prefix]= dbo.fn_wordcap([name_prefix]),
 [address_line_1]= dbo.fn_wordcap([address_line_1])

UPDATE c_User
SET [first_name] = dbo.fn_wordcap([first_name]),
 [last_name] = dbo.fn_wordcap([last_name]),
 [middle_name]= dbo.fn_wordcap([middle_name]),
 [name_prefix]= dbo.fn_wordcap([name_prefix]),
 degree= CASE WHEN UPPER(degree) = 'PHD' THEN 'PhD' 
				WHEN UPPER(degree) = 'PH.D.' THEN 'Ph.D.' 
				ELSE UPPER(degree) END,
 user_full_name = dbo.fn_wordcap(user_full_name) 

UPDATE p_Patient_Progress
SET progress_value = dbo.fn_wordcap(progress_value)
WHERE progress_key like '%name%' OR progress_key = 'address_line_1'
