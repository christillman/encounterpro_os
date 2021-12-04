$PBExportHeader$w_svc_maintenance_rule_status.srw
forward
global type w_svc_maintenance_rule_status from w_window_base
end type
type st_title from statictext within w_svc_maintenance_rule_status
end type
type st_2 from statictext within w_svc_maintenance_rule_status
end type
type st_assessment_title from statictext within w_svc_maintenance_rule_status
end type
type st_assessment from statictext within w_svc_maintenance_rule_status
end type
type dw_soap from u_soap_display within w_svc_maintenance_rule_status
end type
type cb_finished from commandbutton within w_svc_maintenance_rule_status
end type
type cb_be_back from commandbutton within w_svc_maintenance_rule_status
end type
type st_1 from statictext within w_svc_maintenance_rule_status
end type
end forward

global type w_svc_maintenance_rule_status from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_title st_title
st_2 st_2
st_assessment_title st_assessment_title
st_assessment st_assessment
dw_soap dw_soap
cb_finished cb_finished
cb_be_back cb_be_back
st_1 st_1
end type
global w_svc_maintenance_rule_status w_svc_maintenance_rule_status

type variables
str_maintenance_rule maintenance_rule
u_component_service service

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();integer li_sts
u_ds_data luo_data
long ll_rows
long i
string ls_procedure_id
string ls_observation_id
string ls_find_string

luo_data = CREATE u_ds_data

ls_find_string = ""

luo_data.set_dataobject("dw_c_Maintenance_Procedure")
ll_rows = luo_data.retrieve(maintenance_rule.maintenance_rule_id)

for i = 1 to ll_rows
	ls_procedure_id = luo_data.object.procedure_id[i]
	ls_find_string += " or procedure_id='" + ls_procedure_id + "'"
next


luo_data.set_dataobject("dw_maintenance_rule_observation_ids")
ll_rows = luo_data.retrieve(maintenance_rule.maintenance_rule_id)

for i = 1 to ll_rows
	ls_observation_id = luo_data.object.observation_id[i]
	ls_find_string += " or observation_id='" + ls_observation_id + "'"
next

if len(ls_find_string) <= 0 then return 0

ls_find_string = replace(ls_find_string, 1, 3, "(") + ")"

li_sts = dw_soap.load_treatment_list(ls_find_string)


return 1

end function

on w_svc_maintenance_rule_status.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_2=create st_2
this.st_assessment_title=create st_assessment_title
this.st_assessment=create st_assessment
this.dw_soap=create dw_soap
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_assessment_title
this.Control[iCurrent+4]=this.st_assessment
this.Control[iCurrent+5]=this.dw_soap
this.Control[iCurrent+6]=this.cb_finished
this.Control[iCurrent+7]=this.cb_be_back
this.Control[iCurrent+8]=this.st_1
end on

on w_svc_maintenance_rule_status.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_2)
destroy(this.st_assessment_title)
destroy(this.st_assessment)
destroy(this.dw_soap)
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.st_1)
end on

event open;call super::open;long ll_menu_id
long ll_maintenance_rule_id
integer li_sts
string ls_treatment_type
u_ds_data luo_data
datetime ldt_begin_date
datetime ldt_end_date
string ls_assessment

service = message.powerobjectparm

// Set the title and sizes
If isvalid(current_patient) and not isnull(current_patient) Then
	title = current_patient.id_line()
End If


service.get_attribute("maintenance_rule_id", ll_maintenance_rule_id)
if isnull(ll_maintenance_rule_id) then
	log.log(this, "w_svc_maintenance_rule_status:open", "No maintenance_rule_id", 4)
	close(this)
	return
end if

maintenance_rule = datalist.get_maintenance_rule(ll_maintenance_rule_id)
if isnull(maintenance_rule.maintenance_rule_id) then
	log.log(this, "w_svc_maintenance_rule_status:open", "Error getting maintenance rule structure", 4)
	close(this)
	return
end if

f_attribute_add_attribute(state_attributes, "maintenance_rule_id", string(ll_maintenance_rule_id))

st_title.text = maintenance_rule.description

if maintenance_rule.assessment_flag = "Y" then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_maintenance_open_assessment_list")
	li_sts = luo_data.retrieve(current_patient.cpr_id, maintenance_rule.maintenance_rule_id)
	if li_sts < 0 then
		log.log(this, "w_svc_maintenance_rule_status:open", "Error getting open assessments", 4)
		close(this)
		return
	end if
	
	if li_sts = 0 then
		luo_data.set_dataobject("dw_maintenance_closed_assessment_list")
		li_sts = luo_data.retrieve(current_patient.cpr_id, maintenance_rule.maintenance_rule_id)
		if li_sts < 0 then
			log.log(this, "w_svc_maintenance_rule_status:open", "Error getting closed assessments", 4)
			close(this)
			return
		end if
		if li_sts = 0 then
			log.log(this, "w_svc_maintenance_rule_status:open", "Qualifying assessment not found", 3)
			st_assessment.text = "N/A"
		end if
	end if
	
	ldt_begin_date = luo_data.object.begin_date[1]
	ldt_end_date = luo_data.object.end_date[1]
	ls_assessment = luo_data.object.assessment[1]
	
	st_assessment.text = string(ldt_begin_date, date_format_string)
	if not isnull(ldt_end_date) then
		st_assessment.text += " : " + string(ldt_end_date, date_format_string)
	end if
	st_assessment.text += "  " + ls_assessment

	DESTROY luo_data
else
	st_assessment.text = "N/A"
end if

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

dw_soap.initialize( )

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_maintenance_rule_status
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_maintenance_rule_status
end type

type st_title from statictext within w_svc_maintenance_rule_status
integer x = 37
integer y = 152
integer width = 2825
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Maintenance Rule Description"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_svc_maintenance_rule_status
integer x = 87
integer y = 384
integer width = 343
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Procedures"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_assessment_title from statictext within w_svc_maintenance_rule_status
integer x = 64
integer y = 284
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Qualifying Assessment:"
boolean focusrectangle = false
end type

type st_assessment from statictext within w_svc_maintenance_rule_status
integer x = 745
integer y = 280
integer width = 2021
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "N/A"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_soap from u_soap_display within w_svc_maintenance_rule_status
integer x = 82
integer y = 460
integer width = 2715
integer height = 1124
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

event selected;call super::selected;refresh()

end event

type cb_finished from commandbutton within w_svc_maintenance_rule_status
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
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

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_svc_maintenance_rule_status
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
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

type st_1 from statictext within w_svc_maintenance_rule_status
integer width = 2921
integer height = 120
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Maintenance Rule Status"
alignment alignment = center!
boolean focusrectangle = false
end type

