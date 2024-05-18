$PBExportHeader$w_em_visit_level_rules.srw
forward
global type w_em_visit_level_rules from w_window_base
end type
type st_highest_level from statictext within w_em_visit_level_rules
end type
type cb_done from commandbutton within w_em_visit_level_rules
end type
type st_title from statictext within w_em_visit_level_rules
end type
type st_documentation_guide from statictext within w_em_visit_level_rules
end type
type dw_rules from u_dw_pick_list within w_em_visit_level_rules
end type
type st_level_title from statictext within w_em_visit_level_rules
end type
type st_type_title from statictext within w_em_visit_level_rules
end type
type st_type_level_title from statictext within w_em_visit_level_rules
end type
type pb_up from u_picture_button within w_em_visit_level_rules
end type
type pb_down from u_picture_button within w_em_visit_level_rules
end type
type st_page from statictext within w_em_visit_level_rules
end type
type st_info from statictext within w_em_visit_level_rules
end type
type st_new_flag from statictext within w_em_visit_level_rules
end type
end forward

global type w_em_visit_level_rules from w_window_base
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_highest_level st_highest_level
cb_done cb_done
st_title st_title
st_documentation_guide st_documentation_guide
dw_rules dw_rules
st_level_title st_level_title
st_type_title st_type_title
st_type_level_title st_type_level_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_info st_info
st_new_flag st_new_flag
end type
global w_em_visit_level_rules w_em_visit_level_rules

type variables

string em_documentation_guide
string new_flag
long encounter_id

u_ds_data rules_passed

end variables

forward prototypes
public function integer set_rules ()
end prototypes

public function integer set_rules ();long ll_rule_rows
long ll_passed_rows
long i
string ls_em_type
long ll_visit_level
long ll_rule_id
string ls_find
long ll_row
string ls_description
string ls_filter
long ll_highest_level

ll_highest_level = 0
st_highest_level.text = "No Rules Passed"

rules_passed.retrieve(current_patient.cpr_id, encounter_id, em_documentation_guide)
ls_filter = "passed_flag='Y'"
rules_passed.setfilter(ls_filter)
rules_passed.filter()

ll_rule_rows = dw_rules.rowcount()
ll_passed_rows = rules_passed.rowcount()

for i = 1 to ll_passed_rows
	ll_visit_level = rules_passed.object.visit_level[i]
	ll_rule_id = rules_passed.object.rule_id[i]
	
	ls_find = "visit_level=" + string(ll_visit_level)
	ls_find += " and rule_id=" + string(ll_rule_id)
	ll_row = dw_rules.find(ls_find, 1, ll_rule_rows)
	if ll_row > 0 then
		if ll_visit_level > ll_highest_level then
			ll_highest_level = ll_visit_level
			st_highest_level.text = dw_rules.object.visit_level_description[ll_row]
		end if
		dw_rules.object.passed_flag[ll_row] = 1
	end if
next

return 1

end function

on w_em_visit_level_rules.create
int iCurrent
call super::create
this.st_highest_level=create st_highest_level
this.cb_done=create cb_done
this.st_title=create st_title
this.st_documentation_guide=create st_documentation_guide
this.dw_rules=create dw_rules
this.st_level_title=create st_level_title
this.st_type_title=create st_type_title
this.st_type_level_title=create st_type_level_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_info=create st_info
this.st_new_flag=create st_new_flag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_highest_level
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_documentation_guide
this.Control[iCurrent+5]=this.dw_rules
this.Control[iCurrent+6]=this.st_level_title
this.Control[iCurrent+7]=this.st_type_title
this.Control[iCurrent+8]=this.st_type_level_title
this.Control[iCurrent+9]=this.pb_up
this.Control[iCurrent+10]=this.pb_down
this.Control[iCurrent+11]=this.st_page
this.Control[iCurrent+12]=this.st_info
this.Control[iCurrent+13]=this.st_new_flag
end on

on w_em_visit_level_rules.destroy
call super::destroy
destroy(this.st_highest_level)
destroy(this.cb_done)
destroy(this.st_title)
destroy(this.st_documentation_guide)
destroy(this.dw_rules)
destroy(this.st_level_title)
destroy(this.st_type_title)
destroy(this.st_type_level_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_info)
destroy(this.st_new_flag)
end on

event open;call super::open;str_popup_return popup_return
str_popup popup
integer li_sts


popup_return.item_count = 0

popup = Message.powerobjectparm

title = current_patient.id_line()

if popup.data_row_count <> 3 then
	log.log(this, "w_em_visit_level_rules:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

em_documentation_guide = popup.items[1]
new_flag = upper(popup.items[2])
encounter_id = long(popup.items[3])

st_title.text = "Visit Level Coding Rules"

if new_flag = "Y" then
	st_new_flag.text = "New Patient"
else
	st_new_flag.text = "Established Patient"
end if

if isnull(em_documentation_guide) then em_documentation_guide = "1997 E&M"
SELECT description
INTO :st_documentation_guide.text
FROM em_documentation_guide
WHERE em_documentation_guide = :em_documentation_guide;
if not tf_check() then
	log.log(this, "w_em_visit_level_rules:open", "Error getting documentation guide", 4)
	closewithreturn(this, popup_return)
	return
end if

dw_rules.settransobject(sqlca)
dw_rules.retrieve(em_documentation_guide, new_flag)
dw_rules.set_page(1, pb_up, pb_down, st_page)

rules_passed = CREATE u_ds_data
rules_passed.set_dataobject("dw_fn_em_visit_rules_passed")

li_sts = set_rules()
if li_sts < 0 then
	log.log(this, "w_em_visit_level_rules:open", "Error setting visit levels", 4)
	closewithreturn(this, popup_return)
	return
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_em_visit_level_rules
integer x = 2857
integer y = 200
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_em_visit_level_rules
end type

type st_highest_level from statictext within w_em_visit_level_rules
integer x = 864
integer y = 272
integer width = 1221
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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

type cb_done from commandbutton within w_em_visit_level_rules
integer x = 2427
integer y = 1584
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
string text = "OK"
end type

event clicked;close(parent)

end event

type st_title from statictext within w_em_visit_level_rules
integer width = 2921
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "EM Visit Level Coding Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_documentation_guide from statictext within w_em_visit_level_rules
integer y = 104
integer width = 2921
integer height = 96
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "1997 Documentation Guidelines for Evaluation and Management Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_rules from u_dw_pick_list within w_em_visit_level_rules
integer x = 64
integer y = 472
integer width = 2647
integer height = 1092
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_em_visit_level_rules"
boolean border = false
end type

type st_level_title from statictext within w_em_visit_level_rules
integer x = 864
integer y = 196
integer width = 1221
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Highest EM Level Achieved"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_title from statictext within w_em_visit_level_rules
integer x = 101
integer y = 400
integer width = 631
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "EM Visit Level"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_level_title from statictext within w_em_visit_level_rules
integer x = 1070
integer y = 400
integer width = 617
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Rule Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_em_visit_level_rules
integer x = 2711
integer y = 480
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_rules.current_page

dw_rules.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_em_visit_level_rules
integer x = 2711
integer y = 604
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_rules.current_page
li_last_page = dw_rules.last_page

dw_rules.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_em_visit_level_rules
integer x = 2565
integer y = 416
integer width = 274
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_info from statictext within w_em_visit_level_rules
integer x = 50
integer y = 1560
integer width = 2272
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "The highlighted records indicated which rules which have passed for this appointment."
boolean focusrectangle = false
end type

type st_new_flag from statictext within w_em_visit_level_rules
integer x = 91
integer y = 296
integer width = 690
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Established Patient"
boolean focusrectangle = false
end type

