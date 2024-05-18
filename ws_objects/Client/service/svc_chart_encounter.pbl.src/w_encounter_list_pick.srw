$PBExportHeader$w_encounter_list_pick.srw
forward
global type w_encounter_list_pick from w_window_base
end type
type st_page from statictext within w_encounter_list_pick
end type
type pb_down from u_picture_button within w_encounter_list_pick
end type
type pb_up from u_picture_button within w_encounter_list_pick
end type
type st_pick_encounter_mode from statictext within w_encounter_list_pick
end type
type st_mode_title from statictext within w_encounter_list_pick
end type
type st_type_title from statictext within w_encounter_list_pick
end type
type st_pick_encounter_type from statictext within w_encounter_list_pick
end type
type st_title from statictext within w_encounter_list_pick
end type
type dw_encounters from u_dw_pick_list within w_encounter_list_pick
end type
type cb_cancel from commandbutton within w_encounter_list_pick
end type
end forward

global type w_encounter_list_pick from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_page st_page
pb_down pb_down
pb_up pb_up
st_pick_encounter_mode st_pick_encounter_mode
st_mode_title st_mode_title
st_type_title st_type_title
st_pick_encounter_type st_pick_encounter_type
st_title st_title
dw_encounters dw_encounters
cb_cancel cb_cancel
end type
global w_encounter_list_pick w_encounter_list_pick

type variables
string cpr_id

string indirect_flag
string encounter_type

string report_service
string summary_report_id

string mode

end variables

forward prototypes
public subroutine display_encounters ()
end prototypes

public subroutine display_encounters ();long ll_encounters

CHOOSE CASE lower(st_pick_encounter_mode.text)
	CASE "direct"
		st_type_title.visible = false
		st_pick_encounter_type.visible = false
		indirect_flag = "D"
	CASE "indirect"
		st_type_title.visible = false
		st_pick_encounter_type.visible = false
		indirect_flag = "I"
	CASE "direct and indirect"
		st_type_title.visible = false
		st_pick_encounter_type.visible = false
		indirect_flag = "[DI]"
	CASE "all"
		st_type_title.visible = false
		st_pick_encounter_type.visible = false
		indirect_flag = "%"
	CASE "specific type"
		st_type_title.visible = true
		st_pick_encounter_type.visible = true
		indirect_flag = "%"
END CHOOSE


dw_encounters.settransobject(sqlca)

ll_encounters = dw_encounters.retrieve(cpr_id, encounter_type, indirect_flag, '%')

dw_encounters.set_page(1, pb_up, pb_down, st_page)

return

end subroutine

on w_encounter_list_pick.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_pick_encounter_mode=create st_pick_encounter_mode
this.st_mode_title=create st_mode_title
this.st_type_title=create st_type_title
this.st_pick_encounter_type=create st_pick_encounter_type
this.st_title=create st_title
this.dw_encounters=create dw_encounters
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_pick_encounter_mode
this.Control[iCurrent+5]=this.st_mode_title
this.Control[iCurrent+6]=this.st_type_title
this.Control[iCurrent+7]=this.st_pick_encounter_type
this.Control[iCurrent+8]=this.st_title
this.Control[iCurrent+9]=this.dw_encounters
this.Control[iCurrent+10]=this.cb_cancel
end on

on w_encounter_list_pick.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_pick_encounter_mode)
destroy(this.st_mode_title)
destroy(this.st_type_title)
destroy(this.st_pick_encounter_type)
destroy(this.st_title)
destroy(this.dw_encounters)
destroy(this.cb_cancel)
end on

event open;call super::open;string ls_encounter_mode
str_popup popup

popup = message.powerobjectparm
cpr_id = popup.items[1]
mode = popup.items[2]

st_pick_encounter_mode.text = "Direct and Indirect"
encounter_type = "%"

summary_report_id = datalist.get_preference("PREFERENCES", "summary_report_id")
if isnull(summary_report_id) then summary_report_id = "{4B657EFA-AB67-482B-9FAB-1764440DF116}"

report_service = "REPORT"

if mode = "PICK" then
	cb_cancel.text = "Cancel"
	cb_cancel.cancel = true
	cb_cancel.default = false
else
	cb_cancel.text = "OK"
	cb_cancel.cancel = false
	cb_cancel.default = true
	cb_cancel.weight = 700 // bold
end if

display_encounters()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounter_list_pick
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounter_list_pick
end type

type st_page from statictext within w_encounter_list_pick
integer x = 2560
integer y = 132
integer width = 311
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_down from u_picture_button within w_encounter_list_pick
integer x = 2405
integer y = 264
integer width = 137
integer height = 116
integer taborder = 30
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;string ls_temp
integer li_page
integer li_last_page

li_page = dw_encounters.current_page
li_last_page = dw_encounters.last_page

dw_encounters.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from u_picture_button within w_encounter_list_pick
integer x = 2405
integer y = 132
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;string ls_temp
integer li_page

li_page = dw_encounters.current_page

dw_encounters.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_pick_encounter_mode from statictext within w_encounter_list_pick
integer x = 2427
integer y = 644
integer width = 407
integer height = 164
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Direct and Indirect"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 5
popup.items[1] = "Direct"
popup.items[2] = "Indirect"
popup.items[3] = "Direct and Indirect"
popup.items[4] = "All"
popup.items[5] = "Specific Type"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count = 0 then return

text = popup_return.items[1]

encounter_type = "%"

if lower(text) = "specific type" then
	st_pick_encounter_type.postevent("clicked")
else
	display_encounters()
end if

end event

type st_mode_title from statictext within w_encounter_list_pick
integer x = 2469
integer y = 560
integer width = 306
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_title from statictext within w_encounter_list_pick
integer x = 2469
integer y = 924
integer width = 306
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_pick_encounter_type from statictext within w_encounter_list_pick
integer x = 2427
integer y = 1012
integer width = 407
integer height = 244
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "D"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

encounter_type = ls_encounter_type
text = datalist.encounter_type_description(encounter_type)

display_encounters()




end event

type st_title from statictext within w_encounter_list_pick
integer width = 2414
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Select Appointment"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_encounters from u_dw_pick_list within w_encounter_list_pick
integer x = 55
integer y = 116
integer width = 2331
integer height = 1648
integer taborder = 10
string dataobject = "dw_sp_get_encounter_list"
boolean border = false
boolean select_computed = false
end type

event computed_clicked;str_attributes lstr_attributes
long ll_encounter_id
ll_encounter_id = object.encounter_id[clicked_row]

f_attribute_add_attribute(lstr_attributes, "report_id", summary_report_id)
f_attribute_add_attribute(lstr_attributes, "destination", "SCREEN")

service_list.do_service(cpr_id, ll_encounter_id, report_service, lstr_attributes)

enable_window()



end event

event selected;call super::selected;str_popup_return popup_return

if mode = "PICK" then
	popup_return.item_count = 1
	popup_return.items[1] = string(object.encounter_id[lastrow])
	closewithreturn(parent, popup_return)
else
	clear_selected()
end if
end event

type cb_cancel from commandbutton within w_encounter_list_pick
integer x = 2427
integer y = 1668
integer width = 407
integer height = 112
integer taborder = 40
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

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)

end event

