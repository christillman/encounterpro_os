-- Would like title casing applied to 'Name Prefix', 'Last Name', 'First Name' , 'Middle Name', 'Address 1' 

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
 degree= dbo.fn_wordcap(degree),
 user_full_name = dbo.fn_wordcap(user_full_name) 
