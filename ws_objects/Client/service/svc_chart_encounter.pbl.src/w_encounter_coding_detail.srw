$PBExportHeader$w_encounter_coding_detail.srw
forward
global type w_encounter_coding_detail from w_window_base
end type
type st_component_level from statictext within w_encounter_coding_detail
end type
type cb_done from commandbutton within w_encounter_coding_detail
end type
type st_title from statictext within w_encounter_coding_detail
end type
type st_documentation_guide from statictext within w_encounter_coding_detail
end type
type dw_component_levels from u_dw_pick_list within w_encounter_coding_detail
end type
type st_level_title from statictext within w_encounter_coding_detail
end type
type st_type_title from statictext within w_encounter_coding_detail
end type
type st_type_level_title from statictext within w_encounter_coding_detail
end type
type cb_review_rules from commandbutton within w_encounter_coding_detail
end type
type pb_up from u_picture_button within w_encounter_coding_detail
end type
type pb_down from u_picture_button within w_encounter_coding_detail
end type
type st_page from statictext within w_encounter_coding_detail
end type
end forward

global type w_encounter_coding_detail from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_component_level st_component_level
cb_done cb_done
st_title st_title
st_documentation_guide st_documentation_guide
dw_component_levels dw_component_levels
st_level_title st_level_title
st_type_title st_type_title
st_type_level_title st_type_level_title
cb_review_rules cb_review_rules
pb_up pb_up
pb_down pb_down
st_page st_page
end type
global w_encounter_coding_detail w_encounter_coding_detail

type variables

string em_documentation_guide
string em_component
long em_component_level
long encounter_id

u_ds_data type_rules_passed

end variables

forward prototypes
public function integer set_type_levels ()
end prototypes

public function integer set_type_levels ();long ll_rows
long ll_rule_rows
long i
string ls_em_type
long ll_em_type_level
string ls_find
long ll_row
string ls_description

ll_rows = dw_component_levels.rowcount()
ll_rule_rows = type_rules_passed.rowcount()

for i = 1 to ll_rows
	ls_em_type = dw_component_levels.object.em_type[i]
	ls_find = "em_type='" + ls_em_type + "'"
	ls_find += " and passed_flag='Y'"
	ll_row = type_rules_passed.find(ls_find, ll_rule_rows, 1)
	if ll_row > 0 then
		ll_em_type_level = type_rules_passed.object.em_type_level[ll_row]
		ls_description = datalist.em_type_level_description(em_component, ls_em_type, ll_em_type_level)
	else
		ll_em_type_level = 0
		ls_description = "<None>"
	end if
	dw_component_levels.object.level_achieved[i] = ll_em_type_level
	dw_component_levels.object.level_description[i] = ls_description
next


return 1

end function

on w_encounter_coding_detail.create
int iCurrent
call super::create
this.st_component_level=create st_component_level
this.cb_done=create cb_done
this.st_title=create st_title
this.st_documentation_guide=create st_documentation_guide
this.dw_component_levels=create dw_component_levels
this.st_level_title=create st_level_title
this.st_type_title=create st_type_title
this.st_type_level_title=create st_type_level_title
this.cb_review_rules=create cb_review_rules
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_component_level
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_documentation_guide
this.Control[iCurrent+5]=this.dw_component_levels
this.Control[iCurrent+6]=this.st_level_title
this.Control[iCurrent+7]=this.st_type_title
this.Control[iCurrent+8]=this.st_type_level_title
this.Control[iCurrent+9]=this.cb_review_rules
this.Control[iCurrent+10]=this.pb_up
this.Control[iCurrent+11]=this.pb_down
this.Control[iCurrent+12]=this.st_page
end on

on w_encounter_coding_detail.destroy
call super::destroy
destroy(this.st_component_level)
destroy(this.cb_done)
destroy(this.st_title)
destroy(this.st_documentation_guide)
destroy(this.dw_component_levels)
destroy(this.st_level_title)
destroy(this.st_type_title)
destroy(this.st_type_level_title)
destroy(this.cb_review_rules)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
end on

event open;call super::open;str_popup_return popup_return
str_popup popup
integer li_sts


popup_return.item_count = 0

popup = Message.powerobjectparm

title = current_patient.id_line()

if popup.data_row_count <> 4 then
	log.log(this, "w_encounter_coding_detail:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

em_documentation_guide = popup.items[1]
em_component = popup.items[2]
em_component_level = long(popup.items[3])
encounter_id = long(popup.items[4])

st_title.text = em_component + " Coding Levels"
st_level_title.text = em_component + " Level Achieved"

if isnull(em_documentation_guide) then em_documentation_guide = "1997 E&M"
SELECT description
INTO :st_documentation_guide.text
FROM em_documentation_guide
WHERE em_documentation_guide = :em_documentation_guide;
if not tf_check() then
	log.log(this, "w_encounter_coding_detail:open", "Error getting documentation guide", 4)
	closewithreturn(this, popup_return)
	return
end if

if em_component_level > 0 then
	st_component_level.text = datalist.em_component_level_description(em_component, em_component_level)
else
	st_component_level.text = "<None>"
end if

dw_component_levels.settransobject(sqlca)
dw_component_levels.retrieve(em_component)
dw_component_levels.set_page(1, pb_up, pb_down, st_page)

type_rules_passed = CREATE u_ds_data
type_rules_passed.set_dataobject("dw_fn_em_type_rules_passed")
type_rules_passed.retrieve(current_patient.cpr_id, encounter_id, em_documentation_guide)
type_rules_passed.setfilter("em_component='" + em_component + "'")
type_rules_passed.filter()

li_sts = set_type_levels()
if li_sts < 0 then
	log.log(this, "w_encounter_coding_detail:open", "Error setting type levels", 4)
	closewithreturn(this, popup_return)
	return
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_encounter_coding_detail
boolean visible = true
integer x = 2674
integer y = 8
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_encounter_coding_detail
end type

type st_component_level from statictext within w_encounter_coding_detail
integer x = 1797
integer y = 352
integer width = 1015
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
string text = "Expanded Problem Focused"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_encounter_coding_detail
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

type st_title from statictext within w_encounter_coding_detail
integer width = 2921
integer height = 108
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Coding Detail"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_documentation_guide from statictext within w_encounter_coding_detail
integer y = 96
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

type dw_component_levels from u_dw_pick_list within w_encounter_coding_detail
integer x = 91
integer y = 344
integer width = 1669
integer height = 1328
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_em_type_levels_achieved"
boolean border = false
end type

event selected;call super::selected;str_popup popup
string ls_em_type
w_em_type_rules lw_em_type_rules

ls_em_type = object.em_type[selected_row]

popup.data_row_count = 4
popup.items[1] = em_documentation_guide
popup.items[2] = em_component
popup.items[3] = ls_em_type
popup.items[4] = string(encounter_id)

openwithparm(lw_em_type_rules, popup, "w_em_type_rules", parent)

clear_selected()

end event

type st_level_title from statictext within w_encounter_coding_detail
integer x = 1737
integer y = 276
integer width = 1138
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
string text = "EM Component Level Achieved"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_title from statictext within w_encounter_coding_detail
integer x = 123
integer y = 272
integer width = 622
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
string text = "History Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_type_level_title from statictext within w_encounter_coding_detail
integer x = 1115
integer y = 216
integer width = 288
integer height = 132
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Level Achieved"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_review_rules from commandbutton within w_encounter_coding_detail
integer x = 1943
integer y = 504
integer width = 727
integer height = 108
integer taborder = 170
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Review Coding Rules"
end type

event clicked;str_popup popup

popup.data_row_count = 4
popup.items[1] = em_documentation_guide
popup.items[2] = em_component
popup.items[3] = string(em_component_level)
popup.items[4] = string(encounter_id)

openwithparm(w_em_component_rules, popup)


end event

type pb_up from u_picture_button within w_encounter_coding_detail
integer x = 1797
integer y = 1452
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_component_levels.current_page

dw_component_levels.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_encounter_coding_detail
integer x = 1797
integer y = 1576
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

li_page = dw_component_levels.current_page
li_last_page = dw_component_levels.last_page

dw_component_levels.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_encounter_coding_detail
integer x = 1797
integer y = 1392
integer width = 274
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

