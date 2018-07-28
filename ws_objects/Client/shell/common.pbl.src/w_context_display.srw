$PBExportHeader$w_context_display.srw
forward
global type w_context_display from w_window_base
end type
type cb_ok from commandbutton within w_context_display
end type
type cb_halt from commandbutton within w_context_display
end type
type dw_display from u_dw_pick_list within w_context_display
end type
type st_1 from statictext within w_context_display
end type
type st_2 from statictext within w_context_display
end type
type st_3 from statictext within w_context_display
end type
type st_4 from statictext within w_context_display
end type
type st_5 from statictext within w_context_display
end type
type st_6 from statictext within w_context_display
end type
type st_service from statictext within w_context_display
end type
type st_patient from statictext within w_context_display
end type
type st_encounter from statictext within w_context_display
end type
type st_assessment from statictext within w_context_display
end type
type st_treatment from statictext within w_context_display
end type
type cb_tracing from commandbutton within w_context_display
end type
type cb_config_mode from commandbutton within w_context_display
end type
type st_patient_workplan_item_id from statictext within w_context_display
end type
type st_7 from statictext within w_context_display
end type
type st_8 from statictext within w_context_display
end type
type st_9 from statictext within w_context_display
end type
type st_10 from statictext within w_context_display
end type
type st_db_server from statictext within w_context_display
end type
type st_db_database from statictext within w_context_display
end type
type st_db_dbms from statictext within w_context_display
end type
type st_db_spid from statictext within w_context_display
end type
type st_15 from statictext within w_context_display
end type
type st_cpr_id from statictext within w_context_display
end type
type st_encounter_id from statictext within w_context_display
end type
type st_problem_id from statictext within w_context_display
end type
type st_treatment_id from statictext within w_context_display
end type
type st_treatment_workplan from statictext within w_context_display
end type
type st_treatment_workplan_title from statictext within w_context_display
end type
type st_assessment_workplan from statictext within w_context_display
end type
type st_assessment_workplan_title from statictext within w_context_display
end type
type st_service_workplan from statictext within w_context_display
end type
type st_service_workplan_title from statictext within w_context_display
end type
type st_encounter_workplan from statictext within w_context_display
end type
type st_encounter_workplan_title from statictext within w_context_display
end type
type st_11 from statictext within w_context_display
end type
type st_client from statictext within w_context_display
end type
type pb_patient_doc from picturebutton within w_context_display
end type
type pb_encounter_doc from picturebutton within w_context_display
end type
type pb_assessment_doc from picturebutton within w_context_display
end type
type pb_treatment_doc from picturebutton within w_context_display
end type
type cb_log from commandbutton within w_context_display
end type
type st_version from statictext within w_context_display
end type
type cb_temp_dir from commandbutton within w_context_display
end type
type cb_debug_dir from commandbutton within w_context_display
end type
end forward

global type w_context_display from w_window_base
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_ok cb_ok
cb_halt cb_halt
dw_display dw_display
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
st_5 st_5
st_6 st_6
st_service st_service
st_patient st_patient
st_encounter st_encounter
st_assessment st_assessment
st_treatment st_treatment
cb_tracing cb_tracing
cb_config_mode cb_config_mode
st_patient_workplan_item_id st_patient_workplan_item_id
st_7 st_7
st_8 st_8
st_9 st_9
st_10 st_10
st_db_server st_db_server
st_db_database st_db_database
st_db_dbms st_db_dbms
st_db_spid st_db_spid
st_15 st_15
st_cpr_id st_cpr_id
st_encounter_id st_encounter_id
st_problem_id st_problem_id
st_treatment_id st_treatment_id
st_treatment_workplan st_treatment_workplan
st_treatment_workplan_title st_treatment_workplan_title
st_assessment_workplan st_assessment_workplan
st_assessment_workplan_title st_assessment_workplan_title
st_service_workplan st_service_workplan
st_service_workplan_title st_service_workplan_title
st_encounter_workplan st_encounter_workplan
st_encounter_workplan_title st_encounter_workplan_title
st_11 st_11
st_client st_client
pb_patient_doc pb_patient_doc
pb_encounter_doc pb_encounter_doc
pb_assessment_doc pb_assessment_doc
pb_treatment_doc pb_treatment_doc
cb_log cb_log
st_version st_version
cb_temp_dir cb_temp_dir
cb_debug_dir cb_debug_dir
end type
global w_context_display w_context_display

type variables
str_p_patient_wp service_patient_workplan
str_p_patient_wp encounter_patient_workplan
str_p_patient_wp assessment_patient_workplan
str_p_patient_wp treatment_patient_workplan

end variables

forward prototypes
public function integer load_service ()
end prototypes

public function integer load_service ();str_attributes lstr_attributes
integer i
long ll_row
str_c_workplan lstr_c_workplan
integer li_sts
str_p_patient_wp lstr_patient_workplan
long ll_patient_workplan_id

st_db_server.text = sqlca.servername
st_db_database.text = sqlca.database
st_db_dbms.text = sqlca.dbms

if sqlca.connected then
	st_db_spid.text = string(sqlca.spid)
else
	st_db_spid.text = "Not Connected"
end if	

st_client.text = computername + "/" + windows_logon_id

if computer_id > 0 then
	st_client.text += "  (" + string(computer_id) + ")"
end if

if isnull(current_service) then
	st_service.text = "N/A"
	return 0
end if

st_cpr_id.text = ""
st_encounter_id.text = ""
st_problem_id.text = ""
st_treatment_id.text = ""

service_patient_workplan.patient_workplan_id = 0
encounter_patient_workplan.patient_workplan_id = 0
assessment_patient_workplan.patient_workplan_id = 0
treatment_patient_workplan.patient_workplan_id = 0
st_service_workplan.visible = false
st_service_workplan_title.visible = false
st_encounter_workplan.visible = false
st_encounter_workplan_title.visible = false
st_assessment_workplan.visible = false
st_assessment_workplan_title.visible = false
st_treatment_workplan.visible = false
st_treatment_workplan_title.visible = false
pb_patient_doc.visible = false
pb_encounter_doc.visible = false
pb_assessment_doc.visible = false
pb_treatment_doc.visible = false

st_service.text = current_service.service
if len(current_service.description) > 0 then
	st_service.text += ", " + current_service.description
end if
st_patient_workplan_item_id.text = string(current_service.patient_workplan_item_id)
ll_patient_workplan_id = current_service.patient_workplan_id
if ll_patient_workplan_id > 0 then
	li_sts = datalist.clinical_data_cache.patient_workplan(ll_patient_workplan_id, service_patient_workplan)
	st_service_workplan.text = service_patient_workplan.description
	st_service_workplan.visible = true
	st_service_workplan_title.visible = true
end if


if isnull(current_patient) then
	st_patient.text = "N/A"
else
	pb_patient_doc.visible = true
	st_cpr_id.text = current_patient.cpr_id
	st_patient.text = current_patient.id_line()
	if isnull(current_service.encounter_id) then
		st_encounter.text = "N/A"
	else
		pb_encounter_doc.visible = true
		st_encounter_id.text = string(current_service.encounter_id)
		st_encounter.text = current_patient.encounters.encounter_description(current_service.encounter_id)
		li_sts = datalist.clinical_data_cache.patient_object_workplan(current_service.cpr_id, "Encounter", current_service.encounter_id, encounter_patient_workplan)
		if li_sts > 0 then
			st_encounter_workplan.text = encounter_patient_workplan.description
			st_encounter_workplan.visible = true
			st_encounter_workplan_title.visible = true
		end if
	end if
	if isnull(current_service.problem_id) then
		st_assessment.text = "N/A"
	else
		pb_assessment_doc.visible = true
		st_problem_id.text = string(current_service.problem_id)
		st_assessment.text =current_patient.assessments.assessment_description(current_service.problem_id)
		li_sts = datalist.clinical_data_cache.patient_object_workplan(current_service.cpr_id, "Assessment", current_service.problem_id, assessment_patient_workplan)
		if li_sts > 0 then
			st_assessment_workplan.text = assessment_patient_workplan.description
			st_assessment_workplan.visible = true
			st_assessment_workplan_title.visible = true
		end if
	end if
	if isnull(current_service.treatment) then
		st_treatment.text = "N/A"
	else
		pb_treatment_doc.visible = true
		st_treatment_id.text = string(current_service.treatment_id)
		st_treatment.text = current_service.treatment.treatment_description
		li_sts = datalist.clinical_data_cache.patient_object_workplan(current_service.cpr_id, "Treatment", current_service.treatment_id, treatment_patient_workplan)
		if li_sts > 0 then
			st_treatment_workplan.text = treatment_patient_workplan.description
			st_treatment_workplan.visible = true
			st_treatment_workplan_title.visible = true
		end if
	end if
end if

dw_display.object.value.width = dw_display.width - 736

lstr_attributes = current_service.get_attributes()
for i = 1 to lstr_attributes.attribute_count
	ll_row = dw_display.insertrow(0)
	dw_display.object.attribute[ll_row] = lstr_attributes.attribute[i].attribute
	dw_display.object.value[ll_row] = lstr_attributes.attribute[i].value
next

return 1


end function

event open;call super::open;
load_service()

if trace_mode then
	cb_tracing.text = "Tracing is ON"
else
	cb_tracing.text = "Tracing is OFF"
end if

if config_mode then
	cb_config_mode.text = "Config Mode is ON"
else
	cb_config_mode.text = "Config Mode is OFF"
end if

st_version.text = f_app_version()
end event

on w_context_display.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_halt=create cb_halt
this.dw_display=create dw_display
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_5=create st_5
this.st_6=create st_6
this.st_service=create st_service
this.st_patient=create st_patient
this.st_encounter=create st_encounter
this.st_assessment=create st_assessment
this.st_treatment=create st_treatment
this.cb_tracing=create cb_tracing
this.cb_config_mode=create cb_config_mode
this.st_patient_workplan_item_id=create st_patient_workplan_item_id
this.st_7=create st_7
this.st_8=create st_8
this.st_9=create st_9
this.st_10=create st_10
this.st_db_server=create st_db_server
this.st_db_database=create st_db_database
this.st_db_dbms=create st_db_dbms
this.st_db_spid=create st_db_spid
this.st_15=create st_15
this.st_cpr_id=create st_cpr_id
this.st_encounter_id=create st_encounter_id
this.st_problem_id=create st_problem_id
this.st_treatment_id=create st_treatment_id
this.st_treatment_workplan=create st_treatment_workplan
this.st_treatment_workplan_title=create st_treatment_workplan_title
this.st_assessment_workplan=create st_assessment_workplan
this.st_assessment_workplan_title=create st_assessment_workplan_title
this.st_service_workplan=create st_service_workplan
this.st_service_workplan_title=create st_service_workplan_title
this.st_encounter_workplan=create st_encounter_workplan
this.st_encounter_workplan_title=create st_encounter_workplan_title
this.st_11=create st_11
this.st_client=create st_client
this.pb_patient_doc=create pb_patient_doc
this.pb_encounter_doc=create pb_encounter_doc
this.pb_assessment_doc=create pb_assessment_doc
this.pb_treatment_doc=create pb_treatment_doc
this.cb_log=create cb_log
this.st_version=create st_version
this.cb_temp_dir=create cb_temp_dir
this.cb_debug_dir=create cb_debug_dir
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_halt
this.Control[iCurrent+3]=this.dw_display
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.st_6
this.Control[iCurrent+10]=this.st_service
this.Control[iCurrent+11]=this.st_patient
this.Control[iCurrent+12]=this.st_encounter
this.Control[iCurrent+13]=this.st_assessment
this.Control[iCurrent+14]=this.st_treatment
this.Control[iCurrent+15]=this.cb_tracing
this.Control[iCurrent+16]=this.cb_config_mode
this.Control[iCurrent+17]=this.st_patient_workplan_item_id
this.Control[iCurrent+18]=this.st_7
this.Control[iCurrent+19]=this.st_8
this.Control[iCurrent+20]=this.st_9
this.Control[iCurrent+21]=this.st_10
this.Control[iCurrent+22]=this.st_db_server
this.Control[iCurrent+23]=this.st_db_database
this.Control[iCurrent+24]=this.st_db_dbms
this.Control[iCurrent+25]=this.st_db_spid
this.Control[iCurrent+26]=this.st_15
this.Control[iCurrent+27]=this.st_cpr_id
this.Control[iCurrent+28]=this.st_encounter_id
this.Control[iCurrent+29]=this.st_problem_id
this.Control[iCurrent+30]=this.st_treatment_id
this.Control[iCurrent+31]=this.st_treatment_workplan
this.Control[iCurrent+32]=this.st_treatment_workplan_title
this.Control[iCurrent+33]=this.st_assessment_workplan
this.Control[iCurrent+34]=this.st_assessment_workplan_title
this.Control[iCurrent+35]=this.st_service_workplan
this.Control[iCurrent+36]=this.st_service_workplan_title
this.Control[iCurrent+37]=this.st_encounter_workplan
this.Control[iCurrent+38]=this.st_encounter_workplan_title
this.Control[iCurrent+39]=this.st_11
this.Control[iCurrent+40]=this.st_client
this.Control[iCurrent+41]=this.pb_patient_doc
this.Control[iCurrent+42]=this.pb_encounter_doc
this.Control[iCurrent+43]=this.pb_assessment_doc
this.Control[iCurrent+44]=this.pb_treatment_doc
this.Control[iCurrent+45]=this.cb_log
this.Control[iCurrent+46]=this.st_version
this.Control[iCurrent+47]=this.cb_temp_dir
this.Control[iCurrent+48]=this.cb_debug_dir
end on

on w_context_display.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_halt)
destroy(this.dw_display)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_5)
destroy(this.st_6)
destroy(this.st_service)
destroy(this.st_patient)
destroy(this.st_encounter)
destroy(this.st_assessment)
destroy(this.st_treatment)
destroy(this.cb_tracing)
destroy(this.cb_config_mode)
destroy(this.st_patient_workplan_item_id)
destroy(this.st_7)
destroy(this.st_8)
destroy(this.st_9)
destroy(this.st_10)
destroy(this.st_db_server)
destroy(this.st_db_database)
destroy(this.st_db_dbms)
destroy(this.st_db_spid)
destroy(this.st_15)
destroy(this.st_cpr_id)
destroy(this.st_encounter_id)
destroy(this.st_problem_id)
destroy(this.st_treatment_id)
destroy(this.st_treatment_workplan)
destroy(this.st_treatment_workplan_title)
destroy(this.st_assessment_workplan)
destroy(this.st_assessment_workplan_title)
destroy(this.st_service_workplan)
destroy(this.st_service_workplan_title)
destroy(this.st_encounter_workplan)
destroy(this.st_encounter_workplan_title)
destroy(this.st_11)
destroy(this.st_client)
destroy(this.pb_patient_doc)
destroy(this.pb_encounter_doc)
destroy(this.pb_assessment_doc)
destroy(this.pb_treatment_doc)
destroy(this.cb_log)
destroy(this.st_version)
destroy(this.cb_temp_dir)
destroy(this.cb_debug_dir)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_context_display
integer x = 2857
integer y = 124
integer width = 256
integer height = 128
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_context_display
integer x = 46
integer y = 1544
integer height = 36
end type

type cb_ok from commandbutton within w_context_display
integer x = 2432
integer y = 1636
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean cancel = true
boolean default = true
end type

event clicked;close(parent)

end event

type cb_halt from commandbutton within w_context_display
integer x = 46
integer y = 1636
integer width = 576
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Exit EncounterPRO"
end type

event clicked;halt close
end event

type dw_display from u_dw_pick_list within w_context_display
integer x = 1317
integer y = 968
integer width = 1467
integer height = 596
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_attribute_value_display"
boolean vscrollbar = true
end type

type st_1 from statictext within w_context_display
integer x = 1317
integer y = 900
integer width = 672
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
string text = "Service Attributes"
boolean focusrectangle = false
end type

type st_2 from statictext within w_context_display
integer x = 82
integer y = 724
integer width = 402
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
string text = "Service:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_context_display
integer x = 87
integer y = 16
integer width = 402
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
string text = "Patient:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_context_display
integer x = 82
integer y = 124
integer width = 402
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
string text = "Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_context_display
integer x = 82
integer y = 324
integer width = 402
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
string text = "Assessment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_6 from statictext within w_context_display
integer x = 82
integer y = 520
integer width = 402
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
string text = "Treatment:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_service from statictext within w_context_display
integer x = 526
integer y = 720
integer width = 1710
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_patient from statictext within w_context_display
integer x = 530
integer y = 12
integer width = 1710
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_encounter from statictext within w_context_display
integer x = 526
integer y = 120
integer width = 1710
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_assessment from statictext within w_context_display
integer x = 526
integer y = 320
integer width = 1710
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_treatment from statictext within w_context_display
integer x = 526
integer y = 516
integer width = 1710
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type cb_tracing from commandbutton within w_context_display
integer x = 50
integer y = 1504
integer width = 581
integer height = 88
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tracing is OFF"
end type

event clicked;open(w_trace_control)

if trace_mode then
	cb_tracing.text = "Tracing is ON"
else
	cb_tracing.text = "Tracing is OFF"
end if

end event

type cb_config_mode from commandbutton within w_context_display
integer x = 695
integer y = 1504
integer width = 581
integer height = 88
integer taborder = 31
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Config Mode is OFF"
end type

event clicked;

if config_mode then
	config_mode = false
	cb_config_mode.text = "Config Mode is OFF"
else
	config_mode = true
	cb_config_mode.text = "Config Mode is ON"
end if

end event

type st_patient_workplan_item_id from statictext within w_context_display
integer x = 2386
integer y = 724
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "######"
boolean focusrectangle = false
end type

type st_7 from statictext within w_context_display
integer x = 78
integer y = 992
integer width = 402
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
string text = "Server:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_8 from statictext within w_context_display
integer x = 78
integer y = 1096
integer width = 402
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
string text = "Database:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_9 from statictext within w_context_display
integer x = 78
integer y = 1200
integer width = 402
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
string text = "DBMS:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_10 from statictext within w_context_display
integer x = 78
integer y = 1304
integer width = 402
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
string text = "spid:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_db_server from statictext within w_context_display
integer x = 521
integer y = 988
integer width = 699
integer height = 76
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

type st_db_database from statictext within w_context_display
integer x = 521
integer y = 1092
integer width = 699
integer height = 76
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

type st_db_dbms from statictext within w_context_display
integer x = 521
integer y = 1196
integer width = 699
integer height = 76
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

type st_db_spid from statictext within w_context_display
integer x = 521
integer y = 1300
integer width = 699
integer height = 76
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

type st_15 from statictext within w_context_display
integer x = 379
integer y = 892
integer width = 672
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Database Connection"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_cpr_id from statictext within w_context_display
integer x = 2386
integer y = 16
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "######"
boolean focusrectangle = false
end type

type st_encounter_id from statictext within w_context_display
integer x = 2386
integer y = 124
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "######"
boolean focusrectangle = false
end type

type st_problem_id from statictext within w_context_display
integer x = 2386
integer y = 324
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "######"
boolean focusrectangle = false
end type

type st_treatment_id from statictext within w_context_display
integer x = 2386
integer y = 520
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "######"
boolean focusrectangle = false
end type

type st_treatment_workplan from statictext within w_context_display
integer x = 818
integer y = 604
integer width = 1417
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_window_base lw_window

str_context lstr_context

lstr_context.cpr_id = current_service.cpr_id
lstr_context.context_object = "Treatment"
lstr_context.object_key = current_service.treatment_id

openwithparm(lw_window, lstr_context, "w_patient_workplan_display")


end event

type st_treatment_workplan_title from statictext within w_context_display
integer x = 526
integer y = 608
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Workplan:"
boolean focusrectangle = false
end type

type st_assessment_workplan from statictext within w_context_display
integer x = 818
integer y = 408
integer width = 1417
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_context lstr_context

lstr_context.cpr_id = current_service.cpr_id
lstr_context.context_object = "Assessment"
lstr_context.object_key = current_service.problem_id

w_window_base lw_window
openwithparm(lw_window, lstr_context, "w_patient_workplan_display")

end event

type st_assessment_workplan_title from statictext within w_context_display
integer x = 526
integer y = 412
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Workplan:"
boolean focusrectangle = false
end type

type st_service_workplan from statictext within w_context_display
integer x = 818
integer y = 808
integer width = 1417
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;w_window_base lw_window

openwithparm(lw_window, service_patient_workplan, "w_patient_workplan_display")


end event

type st_service_workplan_title from statictext within w_context_display
integer x = 526
integer y = 812
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Workplan:"
boolean focusrectangle = false
end type

type st_encounter_workplan from statictext within w_context_display
integer x = 818
integer y = 208
integer width = 1417
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_context lstr_context

lstr_context.cpr_id = current_service.cpr_id
lstr_context.context_object = "Encounter"
lstr_context.object_key = current_service.encounter_id

w_window_base lw_window
openwithparm(lw_window, lstr_context, "w_patient_workplan_display")

end event

type st_encounter_workplan_title from statictext within w_context_display
integer x = 526
integer y = 212
integer width = 283
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Workplan:"
boolean focusrectangle = false
end type

type st_11 from statictext within w_context_display
integer x = 78
integer y = 1408
integer width = 224
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
string text = "Client:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_client from statictext within w_context_display
integer x = 315
integer y = 1404
integer width = 905
integer height = 76
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

type pb_patient_doc from picturebutton within w_context_display
integer x = 2249
integer y = 4
integer width = 128
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button_component_type-Document.gif"
alignment htextalign = left!
end type

event clicked;string ls_document_component_id
str_attributes lstr_attributes
str_external_observation_attachment lstr_document
integer li_sts
string ls_temp_file
str_popup popup
str_popup_return popup_return

popup.title = "Select Datafile Component"
popup.dataobject = "dw_component_pick"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = "Document"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_document_component_id = popup_return.items[1]

//ls_document_component_id = "JMJDocument"

lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "context_object", "patient")

li_sts = f_create_document(ls_document_component_id, lstr_attributes, lstr_document)
if li_sts < 0 then
	openwithparm(w_pop_message, "Error creating document")
elseif li_sts = 0 then
	openwithparm(w_pop_message, "No document created")
else
	ls_temp_file = f_temp_file("xml")
	li_sts = log.file_write(lstr_document.attachment, ls_temp_file)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "The document was created but failed to write to file (" + ls_temp_file + ")")
		return
	end if
	f_open_file(ls_temp_file, false)
end if

end event

type pb_encounter_doc from picturebutton within w_context_display
integer x = 2249
integer y = 120
integer width = 128
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button_component_type-Document.gif"
alignment htextalign = left!
end type

event clicked;string ls_document_component_id
str_attributes lstr_attributes
str_external_observation_attachment lstr_document
integer li_sts
string ls_temp_file

ls_document_component_id = "JMJDocument"
lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "context_object", "encounter")

li_sts = f_create_document(ls_document_component_id, lstr_attributes, lstr_document)
if li_sts < 0 then
	openwithparm(w_pop_message, "Error creating document")
elseif li_sts = 0 then
	openwithparm(w_pop_message, "No document created")
else
	ls_temp_file = f_temp_file("xml")
	li_sts = log.file_write(lstr_document.attachment, ls_temp_file)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "The document was created but failed to write to file (" + ls_temp_file + ")")
		return
	end if
	f_open_file(ls_temp_file, false)
end if

end event

type pb_assessment_doc from picturebutton within w_context_display
integer x = 2249
integer y = 320
integer width = 128
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button_component_type-Document.gif"
alignment htextalign = left!
end type

event clicked;string ls_document_component_id
str_attributes lstr_attributes
str_external_observation_attachment lstr_document
integer li_sts
string ls_temp_file

ls_document_component_id = "JMJDocument"
lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "context_object", "assessment")

li_sts = f_create_document(ls_document_component_id, lstr_attributes, lstr_document)
if li_sts < 0 then
	openwithparm(w_pop_message, "Error creating document")
elseif li_sts = 0 then
	openwithparm(w_pop_message, "No document created")
else
	ls_temp_file = f_temp_file("xml")
	li_sts = log.file_write(lstr_document.attachment, ls_temp_file)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "The document was created but failed to write to file (" + ls_temp_file + ")")
		return
	end if
	f_open_file(ls_temp_file, false)
end if

end event

type pb_treatment_doc from picturebutton within w_context_display
integer x = 2249
integer y = 516
integer width = 128
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "button_component_type-Document.gif"
alignment htextalign = left!
end type

event clicked;string ls_document_component_id
str_attributes lstr_attributes
str_external_observation_attachment lstr_document
integer li_sts
string ls_temp_file

ls_document_component_id = "JMJDocument"
lstr_attributes = f_get_context_attributes()
f_attribute_add_attribute(lstr_attributes, "context_object", "treatment")

li_sts = f_create_document(ls_document_component_id, lstr_attributes, lstr_document)
if li_sts < 0 then
	openwithparm(w_pop_message, "Error creating document")
elseif li_sts = 0 then
	openwithparm(w_pop_message, "No document created")
else
	ls_temp_file = f_temp_file("xml")
	li_sts = log.file_write(lstr_document.attachment, ls_temp_file)
	if li_sts <= 0 then
		openwithparm(w_pop_message, "The document was created but failed to write to file (" + ls_temp_file + ")")
		return
	end if
	f_open_file(ls_temp_file, false)
end if

end event

type cb_log from commandbutton within w_context_display
integer x = 946
integer y = 1636
integer width = 338
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "View Log"
end type

event clicked;str_log_search lstr_log_search

lstr_log_search.computer_id = computer_id
lstr_log_search.begin_date = datetime(today(), time("00:00"))

openwithparm(w_log_display, lstr_log_search)

end event

type st_version from statictext within w_context_display
integer x = 5
integer y = 1756
integer width = 1166
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean focusrectangle = false
end type

type cb_temp_dir from commandbutton within w_context_display
integer x = 1371
integer y = 1636
integer width = 338
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Temp Dir"
end type

event clicked;f_open_file(temp_path, false)


end event

type cb_debug_dir from commandbutton within w_context_display
integer x = 1797
integer y = 1636
integer width = 338
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Debug Dir"
end type

event clicked;f_open_file(debug_path, false)

end event

