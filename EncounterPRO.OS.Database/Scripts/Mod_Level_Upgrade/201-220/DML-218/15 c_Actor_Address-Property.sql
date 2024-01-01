
-- update when fixing bug #14 office contact info
update c_Actor_Address
set country = 'Uganda', state = NULL 
where state = 'Ug'

-- This was incorrectly updated in Ciru's database, it causes an error to occur printing patient letters.
UPDATE [dbo].[c_Property] SET [title]=NULL, [script_language]=NULL, [script]=NULL WHERE [property_id]=1

