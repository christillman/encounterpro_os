HA$PBExportHeader$w_em_type_rules.srw
forward
global type w_em_type_rules from w_window_base
end type
type st_highest_level from statictext within w_em_type_rules
end type
type st_title from statictext within w_em_type_rules
end type
type st_documentation_guide from statictext within w_em_type_rules
end type
type st_level_title from statictext within w_em_type_rules
end type
type tab_rules from u_tab_em_type_rules within w_em_type_rules
end type
type tab_rules from u_tab_em_type_rules within w_em_type_rules
end type
type cb_ok from commandbutton within w_em_type_rules
end type
end forward

global type w_em_type_rules from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_highest_level st_highest_level
st_title st_title
st_documentation_guide st_documentation_guide
st_level_title st_level_title
tab_rules tab_rules
cb_ok cb_ok
end type
global w_em_type_rules w_em_type_rules

type variables

string em_documentation_guide
string em_component
string em_type
long encounter_id

u_ds_data rules_passed

string coding_data_report_id

boolean show_data

end variables

forward prototypes
public function integer refresh ()
public subroutine show_data ()
end prototypes

public function integer refresh ();tab_rules.refresh()

return 1

end function

public subroutine show_data ();
end subroutine

on w_em_type_rules.create
int iCurrent
call super::create
this.st_highest_level=create st_highest_level
this.st_title=create st_title
this.st_documentation_guide=create st_documentation_guide
this.st_level_title=create st_level_title
this.tab_rules=create tab_rules
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_highest_level
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.st_documentation_guide
this.Control[iCurrent+4]=this.st_level_title
this.Control[iCurrent+5]=this.tab_rules
this.Control[iCurrent+6]=this.cb_ok
end on

on w_em_type_rules.destroy
call super::destroy
destroy(this.st_highest_level)
destroy(this.st_title)
destroy(this.st_documentation_guide)
destroy(this.st_level_title)
destroy(this.tab_rules)
destroy(this.cb_ok)
end on

event open;call super::open;str_popup_return popup_return
str_popup popup
integer li_sts

popup_return.item_count = 0

popup = Message.powerobjectparm

title = current_patient.id_line()

if popup.data_row_count <> 4 then
	log.log(this, "open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

em_documentation_guide = popup.items[1]
em_component = popup.items[2]
em_type = popup.items[3]
encounter_id = long(popup.items[4])

st_title.text = em_component + " - " + em_type + " Coding Rules"

if isnull(em_documentation_guide) then em_documentation_guide = "1997 E&M"
SELECT description
INTO :st_documentation_guide.text
FROM em_documentation_guide
WHERE em_documentation_guide = :em_documentation_guide;
if not tf_check() then
	log.log(this, "open", "Error getting documentation guide", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.width = width
st_documentation_guide.width = width

tab_rules.width = width
tab_rules.height =  height - tab_rules.y - 120


cb_ok.x = width - cb_ok.width - 40
cb_ok.y = tab_rules.y + tab_rules.height - cb_ok.height

st_level_title.x = (width - st_level_title.width - st_highest_level.width - 20) / 2
st_highest_level.x = st_level_title.x + st_level_title.width + 20

// Initialize tab
tab_rules.em_documentation_guide = em_documentation_guide
tab_rules.em_component = em_component
tab_rules.em_type = em_type
tab_rules.encounter_id = encounter_id
tab_rules.cpr_id = current_patient.cpr_id
tab_rules.my_window = this
tab_rules.initialize()

tab_rules.resize_tabs(tab_rules.width,tab_rules.height)


refresh()
//li_sts = set_rules()
//if li_sts < 0 then
//	log.log(this, "open", "Error setting type levels", 4)
//	closewithreturn(this, popup_return)
//	return
//end if
//
//cb_show_data.visible = false
//if not isnull(current_service) then
//	coding_data_report_id = current_service.get_attribute("coding_data_report_id")
//	if not isnull(coding_data_report_id) then
//		cb_show_data.visible = true
//	end if
//end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_em_type_rules
integer x = 2857
integer y = 8
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_em_type_rules
end type

type st_highest_level from statictext within w_em_type_rules
integer x = 1102
integer y = 196
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

type st_title from statictext within w_em_type_rules
integer width = 2921
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "EM Component Coding Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_documentation_guide from statictext within w_em_type_rules
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
long backcolor = 33538240
string text = "1997 Documentation Guidelines for Evaluation and Management Services"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_level_title from statictext within w_em_type_rules
integer x = 256
integer y = 220
integer width = 832
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
string text = "Highest EM Level Achieved:"
alignment alignment = right!
boolean focusrectangle = false
end type

type tab_rules from u_tab_em_type_rules within w_em_type_rules
integer y = 328
integer width = 2921
integer height = 1404
integer taborder = 20
end type

event highest_rule_passed;call super::highest_rule_passed;if pl_highest_rule_passed > 0 then
	st_highest_level.text = datalist.em_type_level_description(em_component, em_type, pl_highest_rule_passed)
else
	st_highest_level.text = "<None>"
end if

end event

type cb_ok from commandbutton within w_em_type_rules
integer x = 2459
integer y = 1644
integer width = 443
integer height = 92
integer taborder = 160
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;close(parent)

end event

