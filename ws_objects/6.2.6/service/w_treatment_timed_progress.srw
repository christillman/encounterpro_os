HA$PBExportHeader$w_treatment_timed_progress.srw
forward
global type w_treatment_timed_progress from w_window_base
end type
type dw_progress_notes from u_dw_pick_list within w_treatment_timed_progress
end type
type cb_done from commandbutton within w_treatment_timed_progress
end type
type cb_be_back from commandbutton within w_treatment_timed_progress
end type
type st_progress_type from statictext within w_treatment_timed_progress
end type
type pb_up from u_picture_button within w_treatment_timed_progress
end type
type st_page from statictext within w_treatment_timed_progress
end type
type pb_down from u_picture_button within w_treatment_timed_progress
end type
type cb_add_item from commandbutton within w_treatment_timed_progress
end type
type st_title from statictext within w_treatment_timed_progress
end type
end forward

global type w_treatment_timed_progress from w_window_base
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
dw_progress_notes dw_progress_notes
cb_done cb_done
cb_be_back cb_be_back
st_progress_type st_progress_type
pb_up pb_up
st_page st_page
pb_down pb_down
cb_add_item cb_add_item
st_title st_title
end type
global w_treatment_timed_progress w_treatment_timed_progress

type variables
string cpr_id
long encounter_id

u_component_service service

string progress_type

string sort

boolean progress_key_required
boolean progress_key_enumerated
string progress_key_object

long max_length

string top_20_specific
string top_20_generic

long risk_level

end variables

forward prototypes
public subroutine sort_notes ()
public function string new_progress_key (string ps_progress_key)
public subroutine set_top_20_codes ()
public function integer delete_progress_note (long pl_row)
public subroutine note_menu (long pl_row)
public function integer get_notes ()
public function integer add_items ()
public subroutine set_progress_type (string ps_progress_type)
end prototypes

public subroutine sort_notes ();string ls_sort

if sort = "A" then
	ls_sort = "progress_date_time A"
else
	ls_sort = "progress_date_time D"
end if

dw_progress_notes.setsort(ls_sort)
dw_progress_notes.sort()

end subroutine

public function string new_progress_key (string ps_progress_key);long ll_row
string ls_find
long i
string ls_suffix

i = 1
ls_suffix = ""

DO WHILE true
	if i > 1 then ls_suffix = " (" + string(i) + ")"
	
	ls_find = "progress_key='" + ps_progress_key + ls_suffix + "'"
	ll_row = dw_progress_notes.find(ls_find, 1, dw_progress_notes.rowcount())
	if ll_row <= 0 then exit
LOOP

return ps_progress_key + ls_suffix

end function

public subroutine set_top_20_codes ();
top_20_generic = "TRTPRG|" + progress_type + "|" + service.treatment.treatment_type
top_20_specific = top_20_generic

if not isnull(service.treatment.specialty_id) and trim(service.treatment.specialty_id) <> "" then top_20_specific += "|" + service.treatment.specialty_id

if not isnull(service.treatment.drug_id) and trim(service.treatment.drug_id) <> "" then top_20_specific += "|" + service.treatment.drug_id

if not isnull(service.treatment.procedure_id) and trim(service.treatment.procedure_id) <> "" then top_20_specific += "|" + service.treatment.procedure_id


if len(top_20_specific) > 64 then top_20_specific = left(top_20_specific, 64)


end subroutine

public function integer delete_progress_note (long pl_row);str_popup popup
str_popup_return popup_return
string ls_progress
string ls_progress_key
datetime ldt_progress_date_time
long ll_risk_level

ls_progress_key = dw_progress_notes.object.progress_key[pl_row]
ldt_progress_date_time = dw_progress_notes.object.progress_date_time[pl_row]
setnull(ll_risk_level)

// To delete a progress note, just set it to null
setnull(ls_progress)

current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, progress_type, ls_progress_key, ls_progress, ldt_progress_date_time, ll_risk_level)

get_notes()

return 1

end function

public subroutine note_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed
window lw_pop_buttons
long ll_actual_length
//string ls_progress

ll_actual_length = dw_progress_notes.object.actual_length[pl_row]

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Change Time"
//	popup.button_titles[popup.button_count] = "Change Time"
//	buttons[popup.button_count] = "EDIT"
//end if
//
//if ll_actual_length > max_length then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button17.bmp"
//	popup.button_helps[popup.button_count] = "Display Entire Progress Note"
//	popup.button_titles[popup.button_count] = "Display All"
//	buttons[popup.button_count] = "DISPLAY"
//end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Item"
	popup.button_titles[popup.button_count] = "Delete"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
//	CASE "EDIT"
//		edit_progress_note(pl_row)
	CASE "DISPLAY"
		popup.data_row_count = 1
		popup.title = "Assessment Progress Note"
		popup.items[1] = dw_progress_notes.object.progress[pl_row]
		openwithparm(w_display_large_string, popup)
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to delete this progress note?")
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			delete_progress_note(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer get_notes ();integer li_sts
long ll_row
long i
str_progress_list lstr_progress
u_user luo_user
string ls_progress_key

setnull(ls_progress_key)

dw_progress_notes.reset()

lstr_progress = f_get_progress(current_patient.cpr_id, "Treatment", service.treatment.treatment_id, progress_type, ls_progress_key)

for i = 1 to lstr_progress.progress_count
	luo_user = user_list.find_user(lstr_progress.progress[i].user_id)
	if isnull(luo_user) then continue
	
	ll_row = dw_progress_notes.insertrow(0)
	dw_progress_notes.object.progress_date_time[ll_row] = lstr_progress.progress[i].progress_date_time
	dw_progress_notes.object.progress_key[ll_row] = lstr_progress.progress[i].progress_key
	dw_progress_notes.object.progress[ll_row] = left(lstr_progress.progress[i].progress, max_length)
	dw_progress_notes.object.risk_level[ll_row] = lstr_progress.progress[i].risk_level
	dw_progress_notes.object.description[ll_row] = lstr_progress.progress[i].progress_full_description
	dw_progress_notes.object.user_id[ll_row] = luo_user.user_id
	dw_progress_notes.object.user_short_name[ll_row] = luo_user.user_short_name
	dw_progress_notes.object.user_full_name[ll_row] = luo_user.user_full_name
	dw_progress_notes.object.color[ll_row] = luo_user.color
	dw_progress_notes.object.actual_length[ll_row] = len(lstr_progress.progress[i].progress)
next

dw_progress_notes.sort()

dw_progress_notes.set_page(1, pb_up, pb_down, st_page)

return 1


end function

public function integer add_items ();str_popup popup
str_popup_return popup_return
string ls_progress_key
long ll_row
long i
u_unit luo_unit
string ls_progress
str_picked_drugs lstr_drugs
integer li_item_index
string ls_find
datetime ldt_progress_date_time
long ll_risk_level

popup.item = ""
popup.title = "Please enter the time for this item"

// Edit/Create the progress note
openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return 0

ldt_progress_date_time = datetime(date(popup_return.items[1]), time(popup_return.items[2]))

CHOOSE CASE lower(progress_key_object)
	CASE "drug"
		popup.data_row_count = 1
		popup.items[1] = "TTP|" + service.treatment.treatment_type
		openwithparm(w_pick_drug_cocktail, popup)
		lstr_drugs = message.powerobjectparm
		if lstr_drugs.drug_count < 1 then return 0
		
		for i = 1 to lstr_drugs.drug_count
			ls_progress_key = lstr_drugs.drugs[i].drug_id
			
			if not isnull(lstr_drugs.drugs[i].administer_amount) &
			  and not isnull(lstr_drugs.drugs[i].administer_unit) then
				luo_unit = unit_list.find_unit(lstr_drugs.drugs[i].administer_unit)
				if isnull(luo_unit) then continue
				ls_progress = luo_unit.pretty_amount(lstr_drugs.drugs[i].administer_amount)
				ls_progress += " " + lstr_drugs.drugs[i].administer_unit
			else
				ls_progress = ""
			end if
		
			current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, progress_type, ls_progress_key, ls_progress, ldt_progress_date_time, risk_level)
		next
	CASE ELSE
		if progress_key_enumerated then
			popup.dataobject = "dw_treatment_progress_key_pick"
			popup.datacolumn = 3
			popup.displaycolumn = 3
			if not progress_key_required then
				popup.add_blank_row = true
				popup.blank_text = "<None>"
			end if
			popup.auto_singleton = true
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return 0
			
			ls_progress_key = popup_return.items[1]
		else
			popup.title = "Please select a title for this new progress note"
			popup.argument_count = 1
			popup.argument[1] = "PRGKEY_" + service.treatment.treatment_type
			
			openwithparm(w_pop_prompt_string, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then return 0
			
			ls_progress_key = popup_return.items[1]
		end if
		
		if trim(ls_progress_key) = "" then setnull(ls_progress_key)
		
		if isnull(ls_progress_key) and progress_key_required then
			openwithparm(w_pop_message, "A title is required for this progress note")
			return 0
		end if
		
		// Make sure this progress_key is unique
		ls_progress_key = new_progress_key(ls_progress_key)
		
		// Start preparing the popup structure for the progress note edit screen
		popup.data_row_count = 3
		popup.items[1] = top_20_specific
		popup.items[2] = top_20_generic
		popup.items[3] = ""
		popup.title = st_title.text
		
		
		// Edit/Create the progress note
		openwithparm(w_progress_note_edit, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 2 then return 0
		
		if isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then return 0
		
		ls_progress = popup_return.items[1]
		ll_risk_level = long(popup_return.items[1])
		
		current_patient.treatments.set_treatment_progress(service.treatment.treatment_id, progress_type, ls_progress_key, ls_progress, ll_risk_level)
END CHOOSE

get_notes()

return 1

end function

public subroutine set_progress_type (string ps_progress_type);string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag

progress_type = ps_progress_type
st_progress_type.text = ps_progress_type

SELECT progress_key_required_flag,
		progress_key_enumerated_flag,
		progress_key_object
INTO :ls_progress_key_required_flag,
		:ls_progress_key_enumerated_flag,
		:progress_key_object
FROM c_Treatment_Type_Progress_Type
WHERE treatment_type = :service.treatment.treatment_type
AND progress_type = :progress_type;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	progress_key_required = false
	progress_key_enumerated = false
	setnull(progress_key_object)
else
	progress_key_required = f_string_to_boolean(ls_progress_key_required_flag)
	progress_key_enumerated = f_string_to_boolean(ls_progress_key_enumerated_flag)
end if


end subroutine

on w_treatment_timed_progress.create
int iCurrent
call super::create
this.dw_progress_notes=create dw_progress_notes
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_progress_type=create st_progress_type
this.pb_up=create pb_up
this.st_page=create st_page
this.pb_down=create pb_down
this.cb_add_item=create cb_add_item
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_progress_notes
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_progress_type
this.Control[iCurrent+5]=this.pb_up
this.Control[iCurrent+6]=this.st_page
this.Control[iCurrent+7]=this.pb_down
this.Control[iCurrent+8]=this.cb_add_item
this.Control[iCurrent+9]=this.st_title
end on

on w_treatment_timed_progress.destroy
call super::destroy
destroy(this.dw_progress_notes)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_progress_type)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.cb_add_item)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag
integer li_count

popup_return.item_count = 0

service = message.powerobjectparm

if isnull(service.treatment) then
	log.log(this, "open", "No Treatment Object", 4)
	closewithreturn(this, popup_return)
	return
end if

service.get_attribute("risk_level", risk_level)

service.get_attribute("progress_note_max_length", max_length)
if isnull(max_length) then max_length = 60

set_top_20_codes()

cpr_id = current_patient.cpr_id
encounter_id = current_patient.open_encounter_id

progress_type = service.get_attribute("progress_type")
if isnull(progress_type) or trim(progress_type) = "" then
	log.log(this, "open", "No progress_type", 4)
	closewithreturn(this, popup_return)
	return
end if

set_progress_type(progress_type)

st_title.text = service.treatment.treatment_description


title = current_patient.id_line()

if len(st_title.text) > 42 then
	if len(st_title.text) > 60 then
		if len(st_title.text) > 70 then
			st_title.textsize = -10
		else
			st_title.textsize = -12
		end if
	else
		st_title.textsize = -14
	end if
else
	st_title.textsize = -18
end if


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

li_sts = get_notes()

return


end event

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_timed_progress
boolean visible = true
integer x = 2624
integer y = 1464
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_treatment_timed_progress
end type

type dw_progress_notes from u_dw_pick_list within w_treatment_timed_progress
integer x = 201
integer y = 232
integer width = 1646
integer height = 1348
integer taborder = 30
string dataobject = "dw_timed_treatment_progress_display"
boolean border = false
end type

event selected;call super::selected;note_menu(selected_row)
clear_selected()

end event

type cb_done from commandbutton within w_treatment_timed_progress
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_treatment_timed_progress
integer x = 1961
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_progress_type from statictext within w_treatment_timed_progress
integer x = 210
integer y = 148
integer width = 1248
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Progress Notes"
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_treatment_progress_type_pick"
popup.argument_count = 1
popup.argument[1] = service.treatment.treatment_type
popup.datacolumn = 2
popup.displaycolumn = 2
popup.auto_singleton = true
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

set_progress_type(popup_return.items[1])

get_notes()

end event

type pb_up from u_picture_button within w_treatment_timed_progress
integer x = 1838
integer y = 240
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_progress_notes.current_page

dw_progress_notes.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within w_treatment_timed_progress
integer x = 1600
integer y = 164
integer width = 366
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_treatment_timed_progress
integer x = 1838
integer y = 376
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_progress_notes.current_page
li_last_page = dw_progress_notes.last_page

dw_progress_notes.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type cb_add_item from commandbutton within w_treatment_timed_progress
integer x = 2162
integer y = 776
integer width = 439
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Item"
end type

event clicked;add_items()

end event

type st_title from statictext within w_treatment_timed_progress
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Treatment Progress Notes"
alignment alignment = center!
boolean focusrectangle = false
end type

