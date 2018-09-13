$PBExportHeader$u_administer_frequency.sru
forward
global type u_administer_frequency from statictext
end type
end forward

global type u_administer_frequency from statictext
integer width = 613
integer height = 68
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_administer_frequency u_administer_frequency

type variables
string administer_frequency
integer current_frequency
integer frequency_count
str_administer_frequency frequencies[]
boolean WasModified
end variables

forward prototypes
public subroutine pretty_text ()
public subroutine set_frequency (string ps_administer_frequency)
public function integer load_frequencies ()
end prototypes

public subroutine pretty_text ();string ls_temp

if isnull(administer_frequency) then
	text = ""
else
	ls_temp = frequencies[current_frequency].administer_frequency &
			+ " - " + frequencies[current_frequency].description
			
	if len(ls_temp) > 22 then
		textsize = -10
	else
		textsize = -12
	end if
	
	text = ls_temp
end if

end subroutine

public subroutine set_frequency (string ps_administer_frequency);integer i

if frequency_count = 0 then
	load_frequencies()
end if

if isnull(ps_administer_frequency) then
	setnull(administer_frequency)
else
	for i = 1 to frequency_count
		if frequencies[i].administer_frequency = ps_administer_frequency then
			administer_frequency = ps_administer_frequency
			current_frequency = i 
			exit
		end if
	next
end if

pretty_text()


end subroutine

public function integer load_frequencies ();string ls_administer_frequency
string ls_description
integer li_frequency

 DECLARE lc_admin_freq CURSOR FOR  
  SELECT c_Administration_Frequency.administer_frequency,   
         c_Administration_Frequency.description,   
         c_Administration_Frequency.frequency  
    FROM c_Administration_Frequency  ;


tf_begin_transaction(this, "")

OPEN lc_admin_freq;
if not tf_check() then return -1

frequency_count = 0

DO
	FETCH lc_admin_freq INTO
		:ls_administer_frequency,
		:ls_description,
		:li_frequency;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 then
		frequency_count = frequency_count + 1
		frequencies[frequency_count].administer_frequency = ls_administer_frequency
		frequencies[frequency_count].description = ls_description
		frequencies[frequency_count].frequency = li_frequency
	end if
LOOP WHILE sqlca.sqlcode = 0

CLOSE lc_admin_freq;

tf_commit()

return 1


end function

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_administer_frequency"
popup.datacolumn = 1
popup.displaycolumn = 4

openwithparm(w_pop_pick, popup)

popup_return = message.powerobjectparm

if popup_return.item_count = 1 then
	set_frequency(popup_return.items[1])
	WasModified = true
end if


end event

on constructor;setnull(administer_frequency)
end on

on u_administer_frequency.create
end on

on u_administer_frequency.destroy
end on

