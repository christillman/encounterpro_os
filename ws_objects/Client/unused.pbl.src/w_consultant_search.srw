$PBExportHeader$w_consultant_search.srw
forward
global type w_consultant_search from w_window_base
end type
type st_specialty from statictext within w_consultant_search
end type
type st_specialty_t from statictext within w_consultant_search
end type
type dw_pick_list from u_dw_pick_list within w_consultant_search
end type
type st_desc from statictext within w_consultant_search
end type
type st_desc_search from statictext within w_consultant_search
end type
type pb_ok from u_picture_button within w_consultant_search
end type
type cb_clear_filter from commandbutton within w_consultant_search
end type
end forward

global type w_consultant_search from w_window_base
string title = "Consultant Search"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_specialty st_specialty
st_specialty_t st_specialty_t
dw_pick_list dw_pick_list
st_desc st_desc
st_desc_search st_desc_search
pb_ok pb_ok
cb_clear_filter cb_clear_filter
end type
global w_consultant_search w_consultant_search

type variables
string specialty_id
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts

dw_pick_list.setredraw(false)
dw_pick_list.reset()
dw_pick_list.setfilter("")
li_sts = dw_pick_list.retrieve(specialty_id)
dw_pick_list.setredraw(true)

Return li_sts
end function

event open;call super::open;string ls_specialty_id
string ls_specialty_description

dw_pick_list.settransobject(sqlca)

ls_specialty_id = message.stringparm
ls_specialty_description = datalist.specialty_description(ls_specialty_id)
if isnull(ls_specialty_description) then
	st_specialty.postevent("clicked")
else
	st_specialty.text = ls_specialty_description
	specialty_id = ls_specialty_id
	refresh()
end if

end event

on w_consultant_search.create
int iCurrent
call super::create
this.st_specialty=create st_specialty
this.st_specialty_t=create st_specialty_t
this.dw_pick_list=create dw_pick_list
this.st_desc=create st_desc
this.st_desc_search=create st_desc_search
this.pb_ok=create pb_ok
this.cb_clear_filter=create cb_clear_filter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specialty
this.Control[iCurrent+2]=this.st_specialty_t
this.Control[iCurrent+3]=this.dw_pick_list
this.Control[iCurrent+4]=this.st_desc
this.Control[iCurrent+5]=this.st_desc_search
this.Control[iCurrent+6]=this.pb_ok
this.Control[iCurrent+7]=this.cb_clear_filter
end on

on w_consultant_search.destroy
call super::destroy
destroy(this.st_specialty)
destroy(this.st_specialty_t)
destroy(this.dw_pick_list)
destroy(this.st_desc)
destroy(this.st_desc_search)
destroy(this.pb_ok)
destroy(this.cb_clear_filter)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_consultant_search
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_consultant_search
end type

type st_specialty from statictext within w_consultant_search
integer x = 1646
integer y = 348
integer width = 1097
integer height = 112
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

event clicked;str_popup_return popup_return
str_popup        popup

popup.dataobject = "dw_specialty_list"
popup.add_blank_row = true
popup.blank_text = "<All Specialties>"
Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	specialty_id = "%"
else
	specialty_id = popup_return.item
End If

refresh()

end event

type st_specialty_t from statictext within w_consultant_search
integer x = 1646
integer y = 276
integer width = 1097
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Specialty"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_pick_list from u_dw_pick_list within w_consultant_search
integer x = 32
integer y = 28
integer width = 1445
integer height = 1680
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_consultant_list"
boolean border = false
end type

type st_desc from statictext within w_consultant_search
integer x = 1646
integer y = 608
integer width = 407
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Filter"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;String ls_filter,ls_description
str_popup_return popup_return


openwithparm(w_pop_get_string_abc, "contains", parent)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_description = lower(popup_return.items[1])

st_desc_search.text = popup_return.descriptions[1]
st_desc_search.visible = true
cb_clear_filter.visible = true
backcolor = color_object_selected

//current_search = "DESCRIPTION"

ls_filter = "lower(description) like '"+ls_description+"'"
dw_pick_list.Setfilter(ls_filter)
dw_pick_list.filter()

end event

type st_desc_search from statictext within w_consultant_search
boolean visible = false
integer x = 2103
integer y = 608
integer width = 640
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_consultant_search
integer x = 2555
integer y = 1420
integer taborder = 11
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;Long					ll_row
str_popup_return 	popup_return

ll_row = dw_pick_list.get_selected_row()
popup_return.item_count = 0
If ll_row > 0 Then
	popup_return.item_count = 2
	popup_return.items[1] = dw_pick_list.object.consultant_id[ll_row]
	popup_return.items[2] = dw_pick_list.object.description[ll_row]
End If
Closewithreturn(Parent,popup_return)

end event

type cb_clear_filter from commandbutton within w_consultant_search
boolean visible = false
integer x = 2400
integer y = 728
integer width = 343
integer height = 88
integer taborder = 21
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Filter"
end type

event clicked;dw_pick_list.Setfilter("")
dw_pick_list.filter()
visible = false
st_desc_search.visible = false
st_desc.backcolor = color_object


end event

