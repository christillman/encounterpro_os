HA$PBExportHeader$w_svc_config_doc_purpose.srw
forward
global type w_svc_config_doc_purpose from w_window_base
end type
type dw_doc_purpose from u_dw_pick_list within w_svc_config_doc_purpose
end type
type st_title from statictext within w_svc_config_doc_purpose
end type
type cb_ok from commandbutton within w_svc_config_doc_purpose
end type
type st_context_object from statictext within w_svc_config_doc_purpose
end type
type st_1 from statictext within w_svc_config_doc_purpose
end type
type st_no_purposes from statictext within w_svc_config_doc_purpose
end type
end forward

global type w_svc_config_doc_purpose from w_window_base
integer width = 2935
integer height = 1840
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
dw_doc_purpose dw_doc_purpose
st_title st_title
cb_ok cb_ok
st_context_object st_context_object
st_1 st_1
st_no_purposes st_no_purposes
end type
global w_svc_config_doc_purpose w_svc_config_doc_purpose

type variables
string context_object

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count

st_context_object.text = wordcap(context_object)

dw_doc_purpose.settransobject(sqlca)
dw_doc_purpose.object.c_workplan_new_description.width = dw_doc_purpose.width - 2250
dw_doc_purpose.object.c_workplan_exists_description.width = dw_doc_purpose.width - 2250
ll_count = dw_doc_purpose.retrieve(context_object)
if ll_count < 0 then return -1

if ll_count = 0 then
	dw_doc_purpose.visible = false
	st_no_purposes.visible = true
	return 0
end if

st_no_purposes.visible = false
dw_doc_purpose.visible = true
return 1

end function

on w_svc_config_doc_purpose.create
int iCurrent
call super::create
this.dw_doc_purpose=create dw_doc_purpose
this.st_title=create st_title
this.cb_ok=create cb_ok
this.st_context_object=create st_context_object
this.st_1=create st_1
this.st_no_purposes=create st_no_purposes
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_doc_purpose
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_ok
this.Control[iCurrent+4]=this.st_context_object
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_no_purposes
end on

on w_svc_config_doc_purpose.destroy
call super::destroy
destroy(this.dw_doc_purpose)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.st_context_object)
destroy(this.st_1)
destroy(this.st_no_purposes)
end on

event open;call super::open;String 	ls_age_range_category
Long		li_rows,ll_find

str_popup_return popup_return

if not isnull(current_patient) then title = current_patient.id_line()

dw_doc_purpose.width = width - 32
dw_doc_purpose.height = height - 550

st_no_purposes.width = width

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 50

pb_epro_help.x = width - pb_epro_help.width - 50
st_title.width = width

context_object = "Treatment"

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_doc_purpose
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_doc_purpose
integer x = 41
integer y = 1616
end type

type dw_doc_purpose from u_dw_pick_list within w_svc_config_doc_purpose
integer x = 14
integer y = 288
integer width = 2889
integer height = 1288
integer taborder = 21
boolean bringtotop = true
string dataobject = "dw_document_purpose_workplans"
boolean vscrollbar = true
boolean border = false
end type

event post_click;call super::post_click;str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context
boolean lb_new_workplan

// What did they click?
if lastcolumnname = "c_workplan_new_description" then
	lb_new_workplan = true
elseif lastcolumnname = "c_workplan_exists_description" then
	lb_new_workplan = false
else
	return
end if

lstr_workplan_context.context_object = context_object
lstr_workplan_context.in_office_flag = "N"

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return

if lb_new_workplan then
	dw_doc_purpose.object.new_object_workplan_id[clicked_row] = lstr_workplan.workplan_id
	dw_doc_purpose.object.c_workplan_new_description[clicked_row] = lstr_workplan.description
else
	dw_doc_purpose.object.existing_object_workplan_id[clicked_row] = lstr_workplan.workplan_id
	dw_doc_purpose.object.c_workplan_exists_description[clicked_row] = lstr_workplan.description
end if

dw_doc_purpose.update()

end event

event buttonclicked;call super::buttonclicked;long ll_workplan_id
w_window_base lw_edit_window
str_popup popup
string ls_id

if row <= 0 then return

CHOOSE CASE lower(dwo.name)
	CASE "b_edit_new"
		ll_workplan_id = object.new_object_workplan_id[row]
	CASE "b_edit_existing"
		ll_workplan_id = object.existing_object_workplan_id[row]
END CHOOSE

if isnull(ll_workplan_id) or ll_workplan_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_workplan
WHERE workplan_id = :ll_workplan_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 2
popup.items[1] = ls_id
popup.items[2] = "true"

openwithparm(lw_edit_window, popup, "w_Workplan_definition_display")

end event

type st_title from statictext within w_svc_config_doc_purpose
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Configure Document Purpose Workplans"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_svc_config_doc_purpose
integer x = 2487
integer y = 1684
integer width = 402
integer height = 112
integer taborder = 11
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

type st_context_object from statictext within w_svc_config_doc_purpose
integer x = 1070
integer y = 148
integer width = 855
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Treatment"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup			popup
str_popup_return popup_return

// get the service type
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "CONTEXT_OBJECT"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

context_object = popup_return.items[1]

text = wordcap(lower(context_object))

refresh()

end event

type st_1 from statictext within w_svc_config_doc_purpose
integer x = 480
integer y = 160
integer width = 562
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
string text = "Context Object:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_no_purposes from statictext within w_svc_config_doc_purpose
boolean visible = false
integer y = 708
integer width = 2926
integer height = 276
boolean bringtotop = true
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "No Purpose Definitions"
alignment alignment = center!
boolean focusrectangle = false
end type

