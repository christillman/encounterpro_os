$PBExportHeader$w_drug_package_selection.srw
forward
global type w_drug_package_selection from w_window_base
end type
type pb_done from u_picture_button within w_drug_package_selection
end type
type pb_cancel from u_picture_button within w_drug_package_selection
end type
type dw_packages from u_dw_pick_list within w_drug_package_selection
end type
type st_title from statictext within w_drug_package_selection
end type
type cb_page_down from commandbutton within w_drug_package_selection
end type
type cb_page_up from commandbutton within w_drug_package_selection
end type
type uo_package from u_package_description within w_drug_package_selection
end type
type cb_new_package from commandbutton within w_drug_package_selection
end type
type st_filter_title from statictext within w_drug_package_selection
end type
type st_form_filter from statictext within w_drug_package_selection
end type
type pb_1 from u_pb_help_button within w_drug_package_selection
end type
end forward

global type w_drug_package_selection from w_window_base
boolean titlebar = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
dw_packages dw_packages
st_title st_title
cb_page_down cb_page_down
cb_page_up cb_page_up
uo_package uo_package
cb_new_package cb_new_package
st_filter_title st_filter_title
st_form_filter st_form_filter
pb_1 pb_1
end type
global w_drug_package_selection w_drug_package_selection

type variables
string package_id
string dosage_form

string package_description


end variables

forward prototypes
public function integer new_package ()
end prototypes

public function integer new_package ();str_popup popup
str_popup_return popup_return
string ls_null

setnull(ls_null)

popup.title = st_form_filter.text
popup.data_row_count = 1
popup.items[1] = dosage_form
openwithparm(w_new_package, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return -1

package_id = popup_return.items[1]
package_description = popup_return.descriptions[1]

return 1

end function

on w_drug_package_selection.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.dw_packages=create dw_packages
this.st_title=create st_title
this.cb_page_down=create cb_page_down
this.cb_page_up=create cb_page_up
this.uo_package=create uo_package
this.cb_new_package=create cb_new_package
this.st_filter_title=create st_filter_title
this.st_form_filter=create st_form_filter
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_packages
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_page_down
this.Control[iCurrent+6]=this.cb_page_up
this.Control[iCurrent+7]=this.uo_package
this.Control[iCurrent+8]=this.cb_new_package
this.Control[iCurrent+9]=this.st_filter_title
this.Control[iCurrent+10]=this.st_form_filter
this.Control[iCurrent+11]=this.pb_1
end on

on w_drug_package_selection.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.dw_packages)
destroy(this.st_title)
destroy(this.cb_page_down)
destroy(this.cb_page_up)
destroy(this.uo_package)
destroy(this.cb_new_package)
destroy(this.st_filter_title)
destroy(this.st_form_filter)
destroy(this.pb_1)
end on

event open;call super::open;
dw_packages.settransobject(sqlca)

dosage_form = datalist.get_preference("PREFERENCES", "default_dosage_form")

postevent("post_open")


end event

event post_open;str_popup_return popup_return

popup_return.item_count = 0

if isnull(dosage_form) then
	st_form_filter.postevent("clicked")
	return
else
	SELECT description
	INTO :st_form_filter.text
	FROM c_Dosage_Form
	WHERE dosage_form = :dosage_form;
	if not tf_check() then
		closewithreturn(this, popup_return)
		return
	end if
	if sqlca.sqlcode = 100 then
		st_form_filter.postevent("clicked")
		return
	end if
end if

dw_packages.retrieve(dosage_form)
dw_packages.set_page(1, cb_page_down.text)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_drug_package_selection
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_drug_package_selection
end type

type pb_done from u_picture_button within w_drug_package_selection
integer x = 2578
integer y = 1552
integer width = 256
integer height = 224
integer taborder = 10
boolean enabled = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if isnull(package_id) then
	openwithparm(w_pop_message, "You must select a package")
	return
end if

popup_return.item_count = 1
popup_return.items[1] = package_id
popup_return.descriptions[1] = package_description

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_drug_package_selection
integer x = 1358
integer y = 1552
integer width = 256
integer height = 224
integer taborder = 70
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type dw_packages from u_dw_pick_list within w_drug_package_selection
integer y = 128
integer width = 1248
integer height = 1664
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_package_list"
boolean border = false
end type

event selected;
package_id = object.package_id[selected_row]
if isnull(package_id) then return

package_description = object.description[selected_row]
uo_package.set_package(package_id)
pb_done.enabled = true
end event

type st_title from statictext within w_drug_package_selection
integer x = 5
integer width = 1211
integer height = 124
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Select Package"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_page_down from commandbutton within w_drug_package_selection
integer x = 1280
integer y = 136
integer width = 370
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 99/99"
end type

event clicked;dw_packages.set_page(dw_packages.current_page + 1, text)

end event

type cb_page_up from commandbutton within w_drug_package_selection
integer x = 1687
integer y = 136
integer width = 174
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Up"
end type

event clicked;dw_packages.set_page(dw_packages.current_page - 1, cb_page_down.text)

end event

type uo_package from u_package_description within w_drug_package_selection
integer x = 1358
integer y = 356
integer taborder = 50
boolean bringtotop = true
end type

on uo_package.destroy
call u_package_description::destroy
end on

type cb_new_package from commandbutton within w_drug_package_selection
integer x = 1870
integer y = 1292
integer width = 421
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Package"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = new_package()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = package_id
popup_return.descriptions[1] = package_description

closewithreturn(parent, popup_return)

end event

type st_filter_title from statictext within w_drug_package_selection
integer x = 1943
integer y = 60
integer width = 891
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Dosage Form Filter"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_form_filter from statictext within w_drug_package_selection
integer x = 1943
integer y = 136
integer width = 891
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
string ls_administer_method_description
real lr_dose_amount
string ls_dose_unit
string ls_administer_unit


popup.dataobject = "dw_dosage_form_list"
popup.title = "Select Dosage Form"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if isnull(popup_return.item) then
	if isnull(dosage_form) then
		openwithparm(w_pop_message, "You must select a dosage form")
		popup_return.item_count = 0
		closewithreturn(parent, popup_return)
	end if
	return 0
end if

dosage_form = popup_return.items[1]
text = popup_return.descriptions[1]

dw_packages.retrieve(dosage_form)
dw_packages.set_page(1, cb_page_down.text)


end event

type pb_1 from u_pb_help_button within w_drug_package_selection
integer x = 1975
integer y = 1596
integer width = 256
integer height = 128
integer taborder = 20
boolean bringtotop = true
end type

