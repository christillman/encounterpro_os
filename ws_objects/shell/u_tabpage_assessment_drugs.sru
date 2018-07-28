HA$PBExportHeader$u_tabpage_assessment_drugs.sru
forward
global type u_tabpage_assessment_drugs from u_tabpage
end type
type st_workplan_description_title from statictext within u_tabpage_assessment_drugs
end type
type pb_down from picturebutton within u_tabpage_assessment_drugs
end type
type pb_up from picturebutton within u_tabpage_assessment_drugs
end type
type st_page from statictext within u_tabpage_assessment_drugs
end type
type dw_drugs from u_dw_pick_list within u_tabpage_assessment_drugs
end type
type cb_add_drug from commandbutton within u_tabpage_assessment_drugs
end type
end forward

global type u_tabpage_assessment_drugs from u_tabpage
integer width = 2894
integer height = 1148
st_workplan_description_title st_workplan_description_title
pb_down pb_down
pb_up pb_up
st_page st_page
dw_drugs dw_drugs
cb_add_drug cb_add_drug
end type
global u_tabpage_assessment_drugs u_tabpage_assessment_drugs

type variables
boolean allow_editing

string assessment_id

// Fields managed on this tab

end variables

forward prototypes
public subroutine drug_menu (long pl_row)
public subroutine refresh ()
public function integer remove_drug (long pl_row)
public function integer add_drug ()
end prototypes

public subroutine drug_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button03.bmp"
	popup.button_helps[popup.button_count] = "Bring up Drug Definition configuration screen"
	popup.button_titles[popup.button_count] = "Edit Drug"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Drug"
	popup.button_titles[popup.button_count] = "Remove Drug"
	buttons[popup.button_count] = "REMOVE"
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
	CASE "EDIT"
//		li_sts = add_drug()
	CASE "REMOVE"
		dw_drugs.deleterow(pl_row)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return

end subroutine

public subroutine refresh ();

dw_drugs.settransobject(sqlca)
dw_drugs.retrieve(assessment_id)

end subroutine

public function integer remove_drug (long pl_row);integer li_sts

dw_drugs.deleterow(pl_row)
li_sts = dw_drugs.update()

return 1


end function

public function integer add_drug ();integer i
long ll_row
str_picked_drugs	lstr_drugs

open(w_pick_drugs)
lstr_drugs = Message.powerobjectparm

for i = 1 to lstr_drugs.drug_count
	ll_row = dw_drugs.insertrow(0)
	dw_drugs.setitem(ll_row, "assessment_id", assessment_id)
	dw_drugs.setitem(ll_row, "drug_id", lstr_drugs.drugs[i].drug_id)
	dw_drugs.setitem(ll_row, "common_name", lstr_drugs.drugs[i].description)
next

return lstr_drugs.drug_count

end function

on u_tabpage_assessment_drugs.create
int iCurrent
call super::create
this.st_workplan_description_title=create st_workplan_description_title
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.dw_drugs=create dw_drugs
this.cb_add_drug=create cb_add_drug
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_workplan_description_title
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.dw_drugs
this.Control[iCurrent+6]=this.cb_add_drug
end on

on u_tabpage_assessment_drugs.destroy
call super::destroy
destroy(this.st_workplan_description_title)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.dw_drugs)
destroy(this.cb_add_drug)
end on

type st_workplan_description_title from statictext within u_tabpage_assessment_drugs
integer width = 2885
integer height = 104
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Drug Allergy Assessment Reactive Drugs"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from picturebutton within u_tabpage_assessment_drugs
integer x = 2318
integer y = 260
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_drugs.current_page
li_last_page = dw_drugs.last_page

dw_drugs.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within u_tabpage_assessment_drugs
integer x = 2318
integer y = 136
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page

li_page = dw_drugs.current_page

dw_drugs.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_assessment_drugs
integer x = 2318
integer y = 388
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "99 of 99"
boolean focusrectangle = false
end type

type dw_drugs from u_dw_pick_list within u_tabpage_assessment_drugs
integer x = 613
integer y = 128
integer width = 1691
integer height = 772
integer taborder = 10
string dataobject = "dw_allergy_assessment_reactive_drug_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;//drug_menu(selected_row)
clear_selected()


end event

type cb_add_drug from commandbutton within u_tabpage_assessment_drugs
integer x = 1065
integer y = 936
integer width = 667
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Drug"
end type

event clicked;add_drug()

end event

