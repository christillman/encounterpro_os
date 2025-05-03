$PBExportHeader$w_new_past_immunization.srw
forward
global type w_new_past_immunization from w_window_base
end type
type st_title from statictext within w_new_past_immunization
end type
type st_maker from statictext within w_new_past_immunization
end type
type st_office from statictext within w_new_past_immunization
end type
type st_office_title from statictext within w_new_past_immunization
end type
type st_location from statictext within w_new_past_immunization
end type
type st_location_title from statictext within w_new_past_immunization
end type
type sle_lot_number from singlelineedit within w_new_past_immunization
end type
type st_lot_number_title from statictext within w_new_past_immunization
end type
type st_1 from statictext within w_new_past_immunization
end type
type st_maker_title from statictext within w_new_past_immunization
end type
type dp_vaccine_date from datepicker within w_new_past_immunization
end type
type cb_pick_vaccine_date from commandbutton within w_new_past_immunization
end type
type cb_cancel from commandbutton within w_new_past_immunization
end type
type cb_ok from commandbutton within w_new_past_immunization
end type
type tab_vaccines from tab within w_new_past_immunization
end type
type tabpage_short_list from userobject within tab_vaccines
end type
type dw_short_list from u_dw_pick_list within tabpage_short_list
end type
type tabpage_short_list from userobject within tab_vaccines
dw_short_list dw_short_list
end type
type tabpage_full_list from userobject within tab_vaccines
end type
type dw_full_list from u_dw_pick_list within tabpage_full_list
end type
type tabpage_full_list from userobject within tab_vaccines
dw_full_list dw_full_list
end type
type tab_vaccines from tab within w_new_past_immunization
tabpage_short_list tabpage_short_list
tabpage_full_list tabpage_full_list
end type
end forward

global type w_new_past_immunization from w_window_base
integer height = 1904
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean nested_user_object_resize = false
st_title st_title
st_maker st_maker
st_office st_office
st_office_title st_office_title
st_location st_location
st_location_title st_location_title
sle_lot_number sle_lot_number
st_lot_number_title st_lot_number_title
st_1 st_1
st_maker_title st_maker_title
dp_vaccine_date dp_vaccine_date
cb_pick_vaccine_date cb_pick_vaccine_date
cb_cancel cb_cancel
cb_ok cb_ok
tab_vaccines tab_vaccines
end type
global w_new_past_immunization w_new_past_immunization

type variables
u_component_service service

string maker_id
string location
string vaccine_office_id
string place_administered

string last_vaccine_find

string top_20_user_id = "$"
string top_20_code = "NEWPASTVACCINE"

boolean short_list_editable

end variables

forward prototypes
public function boolean check_date (date pd_vaccine_date)
public function integer order_treatments ()
public function integer refresh ()
public function integer add_short_list (string ps_drug_id, string ps_description)
public subroutine set_buttons ()
end prototypes

public function boolean check_date (date pd_vaccine_date);
if pd_vaccine_date < date("1/1/1901") then
	openwithparm(w_pop_message, "Invalid Date.  Date must be later than 1/1/1901.")
	return false
end if

if pd_vaccine_date > today() then
	openwithparm(w_pop_message, "Invalid Date.  Date must not be in the future.")
	return false
end if

return true

end function

public function integer order_treatments ();str_attributes lstr_attributes
string ls_treatment_type
string ls_description
long ll_null
long ll_row
string ls_vaccine_id
string ls_vaccine_description
long ll_treatment_id

setnull(ls_description)

ls_treatment_type = service.get_attribute("immunization_treatment_type")
if isnull(ls_treatment_type) then ls_treatment_type = "IMMUNIZATION"


lstr_attributes.attribute_count = 0

f_attribute_add_attribute(lstr_attributes, "begin_date", string(dp_vaccine_date.datevalue))

if not isnull(maker_id) then
	f_attribute_add_attribute(lstr_attributes, "maker_id", maker_id)
end if
	
if not isnull(sle_lot_number.text) and trim(sle_lot_number.text) <> "" then
	f_attribute_add_attribute(lstr_attributes, "lot_number", trim(sle_lot_number.text))
end if
	
if not isnull(location) then
	f_attribute_add_attribute(lstr_attributes, "location", location)
end if

if not isnull(vaccine_office_id) then
	f_attribute_add_attribute(lstr_attributes, "treatment_office_id", vaccine_office_id)
end if
	
if not isnull(place_administered) then
	f_attribute_add_attribute(lstr_attributes, "Place Administered", place_administered)
end if
	
if not isnull(ls_vaccine_description) then
	f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_vaccine_description)
end if


ll_row = tab_vaccines.tabpage_short_list.dw_short_list.get_selected_row()
DO WHILE ll_row > 0
	ls_vaccine_id = tab_vaccines.tabpage_short_list.dw_short_list.object.drug_id[ll_row]
	ls_vaccine_description = tab_vaccines.tabpage_short_list.dw_short_list.object.common_name[ll_row]

	f_attribute_add_attribute(lstr_attributes, "drug_id", ls_vaccine_id)
	f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_vaccine_description)

	ll_treatment_id = current_patient.treatments.order_treatment( &
											current_patient.cpr_id, &
											current_patient.open_encounter_id, &
											ls_treatment_type, &
											ls_description, &
											ll_null, &
											true, &
											current_user.user_id, &
											ll_null, &
											lstr_attributes)
	if ll_treatment_id < 0 then return -1
	
	ll_row = tab_vaccines.tabpage_short_list.dw_short_list.get_selected_row(ll_row)
LOOP

ll_row = tab_vaccines.tabpage_full_list.dw_full_list.get_selected_row()
DO WHILE ll_row > 0
	ls_vaccine_id = tab_vaccines.tabpage_full_list.dw_full_list.object.drug_id[ll_row]
	ls_vaccine_description = tab_vaccines.tabpage_full_list.dw_full_list.object.description[ll_row]

	f_attribute_add_attribute(lstr_attributes, "drug_id", ls_vaccine_id)
	f_attribute_add_attribute(lstr_attributes, "treatment_description", ls_vaccine_description)

	ll_treatment_id = current_patient.treatments.order_treatment( &
											current_patient.cpr_id, &
											current_patient.open_encounter_id, &
											ls_treatment_type, &
											ls_description, &
											ll_null, &
											true, &
											current_user.user_id, &
											ll_null, &
											lstr_attributes)
	if ll_treatment_id < 0 then return -1
	
	ll_row = tab_vaccines.tabpage_full_list.dw_full_list.get_selected_row(ll_row)
LOOP

return 1

end function

public function integer refresh ();string ls_null
long ll_count

setnull(ls_null)

ll_count = tab_vaccines.tabpage_short_list.dw_short_list.retrieve(top_20_user_id, top_20_code)
if ll_count < 0 then return -1

ll_count = tab_vaccines.tabpage_full_list.dw_full_list.retrieve(ls_null, &
																"%", &
																ls_null, &
																ls_null, &
																"OK", &
																"Vaccine")
if ll_count < 0 then return -1

return 1

end function

public function integer add_short_list (string ps_drug_id, string ps_description);long ll_sort_sequence
string ls_null
long ll_null

setnull(ls_null)
setnull(ll_null)

if not current_user.check_privilege("Edit Common Short Lists") then return -99

SELECT max(sort_sequence)
INTO :ll_sort_sequence
FROM u_Top_20
WHERE user_id = :top_20_user_id
AND top_20_code = :top_20_code;
if not tf_check() then return -1

if isnull(ll_sort_sequence) then
	ll_sort_sequence = 1
else
	ll_sort_sequence += 1
end if

INSERT INTO u_Top_20 (
	user_id,
	top_20_code,
	item_text,
	item_id,
	item_id2,
	item_id3,
	sort_sequence)
VALUES (
	:top_20_user_id,
	:top_20_code,
	:ps_description,
	:ps_drug_id,
	:ls_null,
	:ll_null,
	:ll_sort_sequence);
if not tf_check() then return -1


return 1

end function

public subroutine set_buttons ();long ll_count


ll_count = tab_vaccines.tabpage_short_list.dw_short_list.count_selected() + tab_vaccines.tabpage_full_list.dw_full_list.count_selected()
if ll_count > 1 then
	sle_lot_number.visible = false
	st_location.visible = false
	st_maker.visible = false
	st_lot_number_title.visible = false
	st_location_title.visible = false
	st_maker_title.visible = false
else
	sle_lot_number.visible = true
	st_location.visible = true
	st_maker.visible = true
	st_lot_number_title.visible = true
	st_location_title.visible = true
	st_maker_title.visible = true
end if


end subroutine

on w_new_past_immunization.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_maker=create st_maker
this.st_office=create st_office
this.st_office_title=create st_office_title
this.st_location=create st_location
this.st_location_title=create st_location_title
this.sle_lot_number=create sle_lot_number
this.st_lot_number_title=create st_lot_number_title
this.st_1=create st_1
this.st_maker_title=create st_maker_title
this.dp_vaccine_date=create dp_vaccine_date
this.cb_pick_vaccine_date=create cb_pick_vaccine_date
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.tab_vaccines=create tab_vaccines
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_maker
this.Control[iCurrent+3]=this.st_office
this.Control[iCurrent+4]=this.st_office_title
this.Control[iCurrent+5]=this.st_location
this.Control[iCurrent+6]=this.st_location_title
this.Control[iCurrent+7]=this.sle_lot_number
this.Control[iCurrent+8]=this.st_lot_number_title
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_maker_title
this.Control[iCurrent+11]=this.dp_vaccine_date
this.Control[iCurrent+12]=this.cb_pick_vaccine_date
this.Control[iCurrent+13]=this.cb_cancel
this.Control[iCurrent+14]=this.cb_ok
this.Control[iCurrent+15]=this.tab_vaccines
end on

on w_new_past_immunization.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_maker)
destroy(this.st_office)
destroy(this.st_office_title)
destroy(this.st_location)
destroy(this.st_location_title)
destroy(this.sle_lot_number)
destroy(this.st_lot_number_title)
destroy(this.st_1)
destroy(this.st_maker_title)
destroy(this.dp_vaccine_date)
destroy(this.cb_pick_vaccine_date)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.tab_vaccines)
end on

event open;call super::open;str_popup popup
integer li_pos
datetime ldt_default_past_vaccine_date
string ls_cpr_id

service = message.powerobjectparm

dp_vaccine_date.firstdayofweek = f_first_day_of_week()

tab_vaccines.tabpage_short_list.dw_short_list.width = tab_vaccines.tabpage_short_list.width
tab_vaccines.tabpage_short_list.dw_short_list.height = tab_vaccines.tabpage_short_list.height

tab_vaccines.tabpage_full_list.dw_full_list.width = tab_vaccines.tabpage_full_list.width
tab_vaccines.tabpage_full_list.dw_full_list.height = tab_vaccines.tabpage_full_list.height


tab_vaccines.tabpage_short_list.dw_short_list.object.description.width = tab_vaccines.tabpage_short_list.dw_short_list.width - 250
tab_vaccines.tabpage_short_list.dw_short_list.settransobject(sqlca)

tab_vaccines.tabpage_full_list.dw_full_list.object.description.width = tab_vaccines.tabpage_full_list.dw_full_list.width - 250
tab_vaccines.tabpage_full_list.dw_full_list.settransobject(sqlca)

setnull(vaccine_office_id)
setnull(location)
setnull(maker_id)

place_administered = "<Other Location>"
st_office.text = place_administered

cb_ok.enabled = false

short_list_editable = current_user.check_privilege("Edit Common Short Lists")


refresh()

if tab_vaccines.tabpage_short_list.dw_short_list.rowcount() = 0 then
	tab_vaccines.function post selecttab(2)
end if


dp_vaccine_date.setfocus( )


end event

type pb_epro_help from w_window_base`pb_epro_help within w_new_past_immunization
integer x = 2857
integer y = 0
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_new_past_immunization
end type

type st_title from statictext within w_new_past_immunization
integer width = 2926
integer height = 120
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "New Past Immunization"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_maker from statictext within w_new_past_immunization
event clicked pbm_bnclicked
integer x = 1810
integer y = 516
integer width = 809
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_vaccine_id
long ll_row

ll_row = tab_vaccines.tabpage_short_list.dw_short_list.get_selected_row()
if ll_row <= 0 then
	ll_row = tab_vaccines.tabpage_full_list.dw_full_list.get_selected_row()
	if ll_row <= 0 then
		openwithparm(w_pop_message, "You must select a vaccine first")
		return
	else
	ls_vaccine_id = tab_vaccines.tabpage_full_list.dw_full_list.object.drug_id[ll_row]
	end if
else
	ls_vaccine_id = tab_vaccines.tabpage_short_list.dw_short_list.object.drug_id[ll_row]
end if


popup.dataobject = "dw_maker_pick"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.argument_count = 1
popup.argument[1] = ls_vaccine_id
popup.add_blank_row = true
popup.blank_text = "<None>"

openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_new_past_immunizationt.st_maker.clicked:0029")

if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(maker_id)
	text = ""
else
	maker_id = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


sle_lot_number.setfocus()

end event

type st_office from statictext within w_new_past_immunization
event clicked pbm_bnclicked
integer x = 1810
integer y = 1252
integer width = 809
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;integer i
str_popup popup
str_popup_return popup_return
string lsa_user_id[]

popup.dataobject = "dw_pick_office_location"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Other Location>"

openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_new_past_immunizationt.st_office.clicked:0013")

if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(vaccine_office_id)
	popup.displaycolumn = 0
	popup.argument_count = 1
	popup.argument[1] = "New Vaccine Other Location"
	popup.title = "Please specify location where vaccine was administered"
	popup.item = ""
	popup.multiselect = true
	openwithparm(w_pop_prompt_string, popup)
	popup_return = f_popup_return("w_pop_prompt_string,w_new_past_immunizationt.st_office.clicked:0026")
	if popup_return.item_count <> 1 then
		text = "<Other Location>"
	elseif isnull(popup_return.items[1]) or trim(popup_return.items[1]) = "" then
		text = "<Other Location>"
	else
		place_administered = popup_return.items[1]
		text = place_administered
	end if
else
	vaccine_office_id = popup_return.items[1]
	place_administered = popup_return.descriptions[1]
	text = place_administered
end if





end event

type st_office_title from statictext within w_new_past_immunization
integer x = 1445
integer y = 1276
integer width = 338
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Where"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_location from statictext within w_new_past_immunization
integer x = 1810
integer y = 1000
integer width = 809
integer height = 124
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_location_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "!IMMUN"
popup.add_blank_row = true
popup.blank_text = "<None>"

openwithparm(w_pop_pick, popup)
popup_return = f_popup_return("w_pop_pick,w_new_past_immunizationt.st_location.clicked:0013")

if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(location)
	text = ""
else
	location = popup_return.items[1]
	text = popup_return.descriptions[1]
end if




end event

type st_location_title from statictext within w_new_past_immunization
integer x = 1394
integer y = 1024
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Location"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_lot_number from singlelineedit within w_new_past_immunization
integer x = 1810
integer y = 768
integer width = 809
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_lot_number_title from statictext within w_new_past_immunization
integer x = 1349
integer y = 784
integer width = 434
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Lot Number"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_new_past_immunization
integer x = 1577
integer y = 300
integer width = 206
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Date"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_maker_title from statictext within w_new_past_immunization
integer x = 1344
integer y = 540
integer width = 439
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Maker"
alignment alignment = right!
boolean focusrectangle = false
end type

type dp_vaccine_date from datepicker within w_new_past_immunization
event checkkey pbm_keyup
integer x = 1810
integer y = 284
integer width = 809
integer height = 104
integer taborder = 10
boolean bringtotop = true
boolean border = true
borderstyle borderstyle = stylelowered!
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2025-05-03"), Time("14:41:44.000000"))
integer textsize = -10
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
end type

event checkkey;
CHOOSE CASE key
	CASE KeyEnter!
		cb_ok.setfocus( )
END CHOOSE


end event

type cb_pick_vaccine_date from commandbutton within w_new_past_immunization
integer x = 2633
integer y = 296
integer width = 123
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;date ld_vaccine_date
string ls_text

ld_vaccine_date = dp_vaccine_date.datevalue

ls_text = f_select_date(ld_vaccine_date, "Vaccine Date")
if isnull(ls_text) then return

if not check_date(ld_vaccine_date) then return

dp_vaccine_date.setvalue(ld_vaccine_date, time(""))


end event

type cb_cancel from commandbutton within w_new_past_immunization
integer x = 1298
integer y = 1676
integer width = 539
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_attributes lstr_attributes

lstr_attributes.attribute_count = 0

closewithreturn(parent, lstr_attributes)

end event

type cb_ok from commandbutton within w_new_past_immunization
event checkkey pbm_keyup
integer x = 2322
integer y = 1676
integer width = 539
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event checkkey;
CHOOSE CASE key
	CASE KeyEnter!
		this.event post clicked()
END CHOOSE


end event

event clicked;str_attributes lstr_attributes
date ld_date
long ll_row
integer li_sts

ll_row = tab_vaccines.tabpage_short_list.dw_short_list.get_selected_row()
if ll_row <= 0 then
	ll_row = tab_vaccines.tabpage_full_list.dw_full_list.get_selected_row()
	if ll_row <= 0 then
		openwithparm(w_pop_message, "You must select a vaccine first")
		return
	end if
end if

if not check_date(dp_vaccine_date.datevalue) then return

li_sts = order_treatments()
if li_sts < 0 then
	openwithparm(w_pop_message, "An error occured while creating the past immunization records")
	return
end if


close(parent)

end event

type tab_vaccines from tab within w_new_past_immunization
event create ( )
event destroy ( )
integer y = 132
integer width = 1221
integer height = 1660
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean focusonbuttondown = true
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
tabpage_short_list tabpage_short_list
tabpage_full_list tabpage_full_list
end type

on tab_vaccines.create
this.tabpage_short_list=create tabpage_short_list
this.tabpage_full_list=create tabpage_full_list
this.Control[]={this.tabpage_short_list,&
this.tabpage_full_list}
end on

on tab_vaccines.destroy
destroy(this.tabpage_short_list)
destroy(this.tabpage_full_list)
end on

type tabpage_short_list from userobject within tab_vaccines
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 1184
integer height = 1532
long backcolor = 7191717
string text = "Short List"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_short_list dw_short_list
end type

on tabpage_short_list.create
this.dw_short_list=create dw_short_list
this.Control[]={this.dw_short_list}
end on

on tabpage_short_list.destroy
destroy(this.dw_short_list)
end on

event constructor;tab_vaccines.tabpage_short_list.dw_short_list.width = width
tab_vaccines.tabpage_short_list.dw_short_list.height = height

tab_vaccines.tabpage_short_list.dw_short_list.object.description.width = width - 260


end event

type dw_short_list from u_dw_pick_list within tabpage_short_list
integer width = 1102
integer height = 1444
integer taborder = 50
string dataobject = "dw_vaccine_list_short_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean multiselect = true
boolean select_computed = false
end type

event unselected;call super::unselected;set_buttons()

end event

event selected;call super::selected;long ll_count

cb_ok.enabled = true

set_buttons()

dp_vaccine_date.setfocus()

end event

event computed_clicked;call super::computed_clicked;String		lstra_buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description
string		ls_null
String		ls_top_20_code
Integer		li_button_pressed, li_sts, li_service_count
string		ls_report_id
string ls_new_report_id
long ll_null
string ls_status
window 				lw_pop_buttons
str_popup 			popup

Setnull(ls_null)
Setnull(ll_null)

if not short_list_editable then return

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonmove.bmp"
	popup.button_helps[popup.button_count] = "Move vaccine up or down"
	popup.button_titles[popup.button_count] = "Move"
	lstra_buttons[popup.button_count] = "MOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove vaccine from short list"
	popup.button_titles[popup.button_count] = "Remove Short List"
	lstra_buttons[popup.button_count] = "REMOVE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lstra_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lstra_buttons[li_button_pressed]
	CASE "REMOVE"
		deleterow(clicked_row)
		li_sts = update()
	CASE "MOVE"
		li_sts = f_pick_list_move_row(this, clicked_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end event

type tabpage_full_list from userobject within tab_vaccines
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 1184
integer height = 1532
long backcolor = 7191717
string text = "Full List"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_full_list dw_full_list
end type

on tabpage_full_list.create
this.dw_full_list=create dw_full_list
this.Control[]={this.dw_full_list}
end on

on tabpage_full_list.destroy
destroy(this.dw_full_list)
end on

type dw_full_list from u_dw_pick_list within tabpage_full_list
integer width = 1111
integer height = 1304
integer taborder = 60
string dataobject = "dw_sp_drug_search"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
boolean multiselect = true
boolean select_computed = false
end type

event unselected;call super::unselected;set_buttons()

end event

event selected;call super::selected;long ll_count

//vaccine_id = object.vaccine_id[selected_row]
//vaccine_description = object.description[selected_row]
cb_ok.enabled = true

set_buttons()

dp_vaccine_date.setfocus()

end event

event computed_clicked;call super::computed_clicked;String		lstra_buttons[]
String 		ls_drug_id,ls_temp
String 		ls_description
string		ls_null
String		ls_top_20_code
Integer		li_button_pressed, li_sts, li_service_count
string		ls_report_id
string ls_new_report_id
long ll_null
string ls_status
window 				lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return

Setnull(ls_null)
Setnull(ll_null)

if not short_list_editable then return

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_virus.bmp"
	popup.button_helps[popup.button_count] = "Add vaccine to short list"
	popup.button_titles[popup.button_count] = "Add To Short List"
	lstra_buttons[popup.button_count] = "ADD"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lstra_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	li_button_pressed = message.doubleparm
	if li_button_pressed < 1 or li_button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	li_button_pressed = 1
else
	return
end if

CHOOSE CASE lstra_buttons[li_button_pressed]
	CASE "ADD"
		ls_description = object.description[clicked_row]
		ls_drug_id = object.drug_id[clicked_row]
		li_sts = add_short_list(ls_drug_id, ls_description)
		refresh()
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

Return

end event

