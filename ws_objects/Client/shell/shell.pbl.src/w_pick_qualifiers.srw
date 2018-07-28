$PBExportHeader$w_pick_qualifiers.srw
forward
global type w_pick_qualifiers from w_window_base
end type
type pb_cancel from u_picture_button within w_pick_qualifiers
end type
type pb_done from u_picture_button within w_pick_qualifiers
end type
type st_title from statictext within w_pick_qualifiers
end type
type st_no_qualifiers from statictext within w_pick_qualifiers
end type
type ln_1 from line within w_pick_qualifiers
end type
type st_unit from statictext within w_pick_qualifiers
end type
type sle_amount from singlelineedit within w_pick_qualifiers
end type
type cb_amount from commandbutton within w_pick_qualifiers
end type
type st_amount_title from statictext within w_pick_qualifiers
end type
type st_onset from statictext within w_pick_qualifiers
end type
type st_onset_title from statictext within w_pick_qualifiers
end type
type cb_clear_qualifiers from commandbutton within w_pick_qualifiers
end type
type cb_toggle_domains from commandbutton within w_pick_qualifiers
end type
type pb_1 from u_pb_help_button within w_pick_qualifiers
end type
end forward

global type w_pick_qualifiers from w_window_base
int X=0
int Y=0
int Width=2926
int Height=1832
WindowType WindowType=response!
boolean TitleBar=false
long BackColor=33538240
boolean ControlMenu=false
boolean MinBox=false
boolean MaxBox=false
boolean Resizable=false
pb_cancel pb_cancel
pb_done pb_done
st_title st_title
st_no_qualifiers st_no_qualifiers
ln_1 ln_1
st_unit st_unit
sle_amount sle_amount
cb_amount cb_amount
st_amount_title st_amount_title
st_onset st_onset
st_onset_title st_onset_title
cb_clear_qualifiers cb_clear_qualifiers
cb_toggle_domains cb_toggle_domains
pb_1 pb_1
end type
global w_pick_qualifiers w_pick_qualifiers

type variables
string cpr_id
long encounter_id
long treatment_id
string observation_id
string location
integer result_sequence

integer domain_group = 1

datetime encounter_date

real result_amount
u_unit result_unit

u_ds_data selected_results
u_ds_data selected_qualifiers

u_qualifier_pick_list qualifier_domain[]

u_qualifier_pick_list_non_enumerated  non_enumerated_qualifier_domain


real onset_amount
string onset_unit



end variables

forward prototypes
public function integer display_qualifier_domains ()
public function integer save_result_amount ()
public function integer save_onset ()
end prototypes

public function integer display_qualifier_domains ();integer li_sts
u_ds_data luo_data
integer i
long ll_qualifier_domain_id
string ls_category_description
string ls_domain_description
string ls_exclusive_flag
string ls_title
string ls_prefix
integer li_displayed_count
integer li_offset
integer li_next_group_offset
integer li_next_group_count
integer li_enumerated_count
integer li_non_enumerated_count

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_qualifier_domain_list")
li_enumerated_count = luo_data.retrieve(observation_id, result_sequence)

luo_data.setfilter("qualifier_class='ENUMERATED'")
luo_data.filter()

li_enumerated_count = luo_data.rowcount()
li_non_enumerated_count = luo_data.filteredcount()

// Now calculate the offset of the displayed qualifier domains
li_offset = (domain_group - 1) * 3

// If we have some non-enumerated qualifier domains, then shift the offset by one.
if li_non_enumerated_count > 0 then
	li_offset -= 1
end if

// If the domain_group is too high, then set it back to one
if li_offset >= li_enumerated_count then
	domain_group = 1
	li_offset = 0
	if li_non_enumerated_count > 0 then li_offset -= 1
end if

if li_enumerated_count - li_offset > 3 then
	li_displayed_count = 3
else
	li_displayed_count = li_enumerated_count - li_offset
end if

non_enumerated_qualifier_domain.visible = false

for i = 1 to 3
	// If this is the first domain_group and there are non-enumerated domains
	// and this is the first displayed object then display the non-enumerated object
	// instead of the enumerated domain object
	if domain_group = 1 and li_non_enumerated_count > 0 and i = 1 then
		qualifier_domain[i].visible = false
		non_enumerated_qualifier_domain.visible = true
		ls_title = "Non-Enumerated Qualifiers"
		li_sts = non_enumerated_qualifier_domain.initialize(	cpr_id, &
																encounter_id, &
																treatment_id, &
																observation_id, &
																location, &
																result_sequence, &
																ls_title, &
																selected_qualifiers)
		if li_sts < 0 then
			log.log(this, "display_qualifier_domains()", "Error initializing qualifier domain", 4)
			return -1
		end if
	elseif i <= li_displayed_count then
		// If this is to be a 
		qualifier_domain[i].visible = true
		ll_qualifier_domain_id = luo_data.object.qualifier_domain_id[li_offset + i]
		ls_category_description = luo_data.object.category_description[li_offset + i]
		ls_domain_description = luo_data.object.domain_description[li_offset + i]
		ls_title = ls_category_description + "~r~n" + ls_domain_description
		ls_exclusive_flag = luo_data.object.exclusive_flag[li_offset + i]
		ls_prefix = luo_data.object.prefix[li_offset + i]
		li_sts = qualifier_domain[i].initialize(	cpr_id, &
																encounter_id, &
																treatment_id, &
																observation_id, &
																location, &
																result_sequence, &
																ll_qualifier_domain_id, &
																ls_title, &
																ls_prefix, &
																ls_exclusive_flag, &
																selected_qualifiers)
		if li_sts < 0 then
			log.log(this, "display_qualifier_domains()", "Error initializing qualifier domain", 4)
			return -1
		end if
	else
		qualifier_domain[i].visible = false
	end if
next


// Now construct the text for the toggle bar
li_next_group_offset = domain_group * 3
cb_toggle_domains.visible = false

// If there are non-enumerated domains, then shift over one
if li_non_enumerated_count > 0 then
	li_next_group_offset -= 1
	
	// check to see if there are more than two enumerated qualifier domains
	if li_enumerated_count > 2 then
		// If so, then we need the toggle button
		cb_toggle_domains.visible = true
	end if
elseif li_enumerated_count > 3 then
	// If there are more than three enumerated qualifier domains, then we need the toggle button
	cb_toggle_domains.visible = true
end if

// If the next offset exceeds the count, then shift back to the first group
if li_next_group_offset >= li_enumerated_count then li_next_group_offset = 0

if li_non_enumerated_count > 0 and li_next_group_offset = 0 then
	cb_toggle_domains.text = "Non_Enumerated Qualifiers"
	// Calculate how many domains will be displayed
	if li_enumerated_count - li_next_group_offset > 2 then
		li_next_group_count = 2
	else
		li_next_group_count = li_enumerated_count - li_next_group_offset
	end if
else
	cb_toggle_domains.text = ""
	// Calculate how many domains will be displayed
	if li_enumerated_count - li_next_group_offset > 3 then
		li_next_group_count = 3
	else
		li_next_group_count = li_enumerated_count - li_next_group_offset
	end if
end if

for i = 1 to li_next_group_count
	ls_category_description = luo_data.object.category_description[li_next_group_offset + i]
	ls_domain_description = luo_data.object.domain_description[li_next_group_offset + i]
	ls_title = ls_category_description + " " + ls_domain_description
	if cb_toggle_domains.text = "" then
		cb_toggle_domains.text = ls_title
	else
		cb_toggle_domains.text += "; " + ls_title
	end if
next

DESTROY luo_data

return li_enumerated_count + li_non_enumerated_count


end function

public function integer save_result_amount ();integer li_sts
long ll_row
string ls_find

// First, find the record
ls_find = "observation_id='" + observation_id + "'"
ls_find += " and location='" + location + "'"
ls_find += " and result_sequence=" + string(result_sequence)
ll_row = selected_results.find(ls_find, 1, selected_results.rowcount())
if ll_row <= 0 then return -1

// Then update the result amount
selected_results.object.result_amount[ll_row] = result_amount
li_sts = selected_results.update()
if li_sts < 0 then return -1

return 1

end function

public function integer save_onset ();integer li_sts
date ld_result_date
long ll_row
string ls_find
date ld_date


ld_date = date(encounter_date)

// Second, find the record
ls_find = "observation_id='" + observation_id + "'"
ls_find += " and location='" + location + "'"
ls_find += " and result_sequence=" + string(result_sequence)
ll_row = selected_results.find(ls_find, 1, selected_results.rowcount())
if ll_row <= 0 then return -1

if isnull(onset_amount) or isnull(onset_unit) then
	setnull(ld_result_date)
else
	ld_result_date = f_add_interval(ld_date, -int(onset_amount), onset_unit)
end if

// Then update the result amount
selected_results.object.result_date_time[ll_row] = datetime(ld_result_date, time(encounter_date))
li_sts = selected_results.update()
if li_sts < 0 then return -1

return 1

end function

on w_pick_qualifiers.create
int iCurrent
call super::create
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_title=create st_title
this.st_no_qualifiers=create st_no_qualifiers
this.ln_1=create ln_1
this.st_unit=create st_unit
this.sle_amount=create sle_amount
this.cb_amount=create cb_amount
this.st_amount_title=create st_amount_title
this.st_onset=create st_onset
this.st_onset_title=create st_onset_title
this.cb_clear_qualifiers=create cb_clear_qualifiers
this.cb_toggle_domains=create cb_toggle_domains
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_cancel
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_no_qualifiers
this.Control[iCurrent+5]=this.ln_1
this.Control[iCurrent+6]=this.st_unit
this.Control[iCurrent+7]=this.sle_amount
this.Control[iCurrent+8]=this.cb_amount
this.Control[iCurrent+9]=this.st_amount_title
this.Control[iCurrent+10]=this.st_onset
this.Control[iCurrent+11]=this.st_onset_title
this.Control[iCurrent+12]=this.cb_clear_qualifiers
this.Control[iCurrent+13]=this.cb_toggle_domains
this.Control[iCurrent+14]=this.pb_1
end on

on w_pick_qualifiers.destroy
call super::destroy
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_title)
destroy(this.st_no_qualifiers)
destroy(this.ln_1)
destroy(this.st_unit)
destroy(this.sle_amount)
destroy(this.cb_amount)
destroy(this.st_amount_title)
destroy(this.st_onset)
destroy(this.st_onset_title)
destroy(this.cb_clear_qualifiers)
destroy(this.cb_toggle_domains)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_filter
string ls_result_amount_flag
string ls_result_unit
datetime ldt_result_date_time
integer i

popup = message.powerobjectparm

if popup.data_row_count <> 6 then
	log.log(this, "open", "Invalid Parameters", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

st_title.text = popup.title

cpr_id = popup.items[1]
encounter_id = long(popup.items[2])
treatment_id = long(popup.items[3])
observation_id = popup.items[4]
location = popup.items[5]
result_sequence = integer(popup.items[6])

selected_qualifiers = popup.objectparm
selected_results = popup.objectparm2

// First, get the encounter date
SELECT encounter_date
INTO :encounter_date
FROM p_Patient_Encounter
WHERE cpr_id = :cpr_id
AND encounter_id = :encounter_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "open", "encounter not found (" + cpr_id + ", " + string(encounter_id) + ")", 4)
	return -1
end if

// Then get the result data
SELECT c.result_amount_flag,
		 c.result_unit,
		 p.result_amount,
		 p.result_date_time
INTO :ls_result_amount_flag,
	  :ls_result_unit,
	  :result_amount,
	  :ldt_result_date_time
FROM c_Observation_Result c, p_Objective_Result p
WHERE p.cpr_id = :cpr_id
AND p.treatment_id = :treatment_id
AND p.observation_id = :observation_id
AND p.location = :location
AND p.result_sequence = :result_sequence
AND c.observation_id = :observation_id
AND c.result_sequence = :result_sequence;
if not tf_check() then
	log.log(this, "open", "Error getting result", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if
if sqlca.sqlcode = 100 then
	log.log(this, "open", "result not found", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

if ls_result_amount_flag = "Y" then
	st_amount_title.visible = true
	cb_amount.visible = true
	sle_amount.visible = true
	st_unit.visible = true
	result_unit = unit_list.find_unit(ls_result_unit)
	if isnull(result_unit) then
		st_unit.text = ""
	elseif result_unit.print_unit = "Y" then
		st_unit.text = result_unit.description
	else
		st_unit.text = ""
	end if
	sle_amount.text = f_pretty_amount(result_amount, "", result_unit)
else
	st_amount_title.visible = false
	cb_amount.visible = false
	sle_amount.visible = false
	st_unit.visible = false
end if

ls_filter = "observation_id='" + observation_id + "'"
ls_filter += " and location='" + location + "'"
ls_filter += " and result_sequence=" + string(result_sequence)
selected_qualifiers.setfilter(ls_filter)
selected_qualifiers.filter()

// First, create the object to display non-enumerated qualifiers
openuserobject(non_enumerated_qualifier_domain, 150, 184)
if not isvalid(non_enumerated_qualifier_domain) or isnull(non_enumerated_qualifier_domain) then
	log.log(this, "display_qualifier_domains()", "Error opening non-enumerated qualifier domain", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

// Then create three objects to display enumerated qualifiers
for i = 1 to 3
	openuserobject(qualifier_domain[i], 150 + (895 * (i - 1)), 184)
	if not isvalid(qualifier_domain[i]) or isnull(qualifier_domain[i]) then
		log.log(this, "display_qualifier_domains()", "Error opening qualifier domain", 4)
		popup_return.item_count = 0
		closewithreturn(this, popup_return)
		return
	end if
next

li_sts = display_qualifier_domains()
if li_sts < 0 then
	log.log(this, "open", "Error displaying qualifiers", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
elseif li_sts = 0 then
	st_no_qualifiers.visible = true
	cb_clear_qualifiers.visible = false
else
	st_no_qualifiers.visible = false
	cb_clear_qualifiers.visible = true
end if

f_pretty_date_interval(date(ldt_result_date_time), date(encounter_date), onset_amount, onset_unit)
st_onset.text = f_pretty_amount_unit(onset_amount, onset_unit)



end event

type pb_cancel from u_picture_button within w_pick_qualifiers
int X=87
int Y=1556
int TabOrder=60
boolean Visible=false
string PictureName="button11.bmp"
string DisabledName="b_push11.bmp"
boolean Cancel=true
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_pick_qualifiers
int X=2569
int Y=1556
int TabOrder=10
boolean BringToTop=true
string PictureName="button26.bmp"
string DisabledName="b_push26.bmp"
end type

event clicked;call super::clicked;selected_qualifiers.setfilter("")
selected_qualifiers.filter()

close(parent)

end event

type st_title from statictext within w_pick_qualifiers
int Width=2921
int Height=108
boolean Enabled=false
boolean BringToTop=true
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-16
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_no_qualifiers from statictext within w_pick_qualifiers
int X=421
int Y=444
int Width=2053
int Height=184
boolean Enabled=false
boolean BringToTop=true
string Text="No Qualifiers For This Observation"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-18
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type ln_1 from line within w_pick_qualifiers
boolean Enabled=false
int BeginX=128
int BeginY=1520
int EndX=2811
int EndY=1520
int LineThickness=4
long LineColor=33554432
end type

type st_unit from statictext within w_pick_qualifiers
int X=731
int Y=1664
int Width=366
int Height=88
boolean Enabled=false
boolean BringToTop=true
string Text="none"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_amount from singlelineedit within w_pick_qualifiers
int X=119
int Y=1644
int Width=416
int Height=108
int TabOrder=40
boolean BringToTop=true
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event modified;real lr_amount
lr_amount = real(text)

text = f_pretty_amount(lr_amount, "", result_unit)

result_amount = lr_amount

save_result_amount()


end event

type cb_amount from commandbutton within w_pick_qualifiers
int X=562
int Y=1648
int Width=155
int Height=108
int TabOrder=50
boolean BringToTop=true
string Text=". . ."
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.realitem = result_amount
popup.objectparm = result_unit
openwithparm(w_number, popup)
popup_return = message.powerobjectparm
if popup_return.item = "OK" then
	result_amount = popup_return.realitem
	sle_amount.text = f_pretty_amount(popup_return.realitem, "", result_unit)
	save_result_amount()
end if

end event

type st_amount_title from statictext within w_pick_qualifiers
int X=123
int Y=1576
int Width=434
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="Result Amount"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_onset from statictext within w_pick_qualifiers
int X=1243
int Y=1656
int Width=581
int Height=100
boolean BringToTop=true
boolean Border=true
BorderStyle BorderStyle=StyleRaised!
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts

popup.title = st_title.text + " Onset"
popup.data_row_count = 2
popup.items[1] = string(onset_amount)
popup.items[2] = onset_unit
openwithparm(w_pop_time_interval, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

onset_amount = real(popup_return.items[1])
onset_unit = popup_return.items[2]

text = f_pretty_amount_unit(onset_amount, onset_unit)

li_sts = save_onset()

return

end event

type st_onset_title from statictext within w_pick_qualifiers
int X=1253
int Y=1588
int Width=434
int Height=68
boolean Enabled=false
boolean BringToTop=true
string Text="Onset"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_clear_qualifiers from commandbutton within w_pick_qualifiers
int X=2075
int Y=1548
int Width=233
int Height=100
int TabOrder=30
boolean BringToTop=true
string Text="Clear"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;integer i

if non_enumerated_qualifier_domain.visible then	non_enumerated_qualifier_domain.clear_selected()

for i = 1 to 3
	if qualifier_domain[i].visible then	qualifier_domain[i].clear_selected()
next

end event

type cb_toggle_domains from commandbutton within w_pick_qualifiers
int X=123
int Y=1400
int Width=2683
int Height=108
int TabOrder=20
boolean BringToTop=true
string Text="none"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;domain_group += 1

display_qualifier_domains()


end event

type pb_1 from u_pb_help_button within w_pick_qualifiers
int X=2075
int Y=1680
int TabOrder=20
boolean BringToTop=true
end type

