$PBExportHeader$w_scheduled_service_history.srw
forward
global type w_scheduled_service_history from w_window_base
end type
type st_title from statictext within w_scheduled_service_history
end type
type dw_history from u_dw_pick_list within w_scheduled_service_history
end type
type cb_ok from commandbutton within w_scheduled_service_history
end type
end forward

global type w_scheduled_service_history from w_window_base
integer width = 2898
integer height = 1808
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
st_title st_title
dw_history dw_history
cb_ok cb_ok
end type
global w_scheduled_service_history w_scheduled_service_history

type variables
long service_sequence
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();long ll_count

ll_count = dw_history.retrieve(service_sequence)
if ll_count < 0 then return -1


return 1

end function

on w_scheduled_service_history.create
int iCurrent
call super::create
this.st_title=create st_title
this.dw_history=create dw_history
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.dw_history
this.Control[iCurrent+3]=this.cb_ok
end on

on w_scheduled_service_history.destroy
call super::destroy
destroy(this.st_title)
destroy(this.dw_history)
destroy(this.cb_ok)
end on

event open;call super::open;string ls_description
string ls_schedule_description
string ls_user_full_name


service_sequence = message.doubleparm
if isnull(service_sequence) or service_sequence <= 0 then
	log.log(this, "w_scheduled_service_history:open", "Invalid service_sequence", 4)
	close(this)
	return
end if

SELECT description, schedule_description, user_full_name
INTO :ls_description, :ls_schedule_description, :ls_user_full_name
FROM dbo.fn_scheduled_services()
WHERE service_sequence = :service_sequence;
if not tf_check() then
	close(this)
	return
end if

st_title.text = ls_description + ", " + ls_schedule_description + " for " + ls_user_full_name

dw_history.settransobject(sqlca)

if refresh() < 0 then
	log.log(this, "w_scheduled_service_history:open", "Error refreshing screen", 4)
	close(this)
	return
end if

end event

event resize;call super::resize;st_title.width = width

cb_ok.x = width - cb_ok.width - 50
cb_ok.y = height - cb_ok.height - 150

dw_history.x = ((width - 100)  - dw_history.width) / 2
if dw_history.x + dw_history.width + 70 < cb_ok.x then
	dw_history.height = cb_ok.y + cb_ok.height - dw_history.y - 70
else
	dw_history.height = cb_ok.y - dw_history.y - 70
end if




end event

type pb_epro_help from w_window_base`pb_epro_help within w_scheduled_service_history
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_scheduled_service_history
end type

type st_title from statictext within w_scheduled_service_history
integer width = 2903
integer height = 128
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_history from u_dw_pick_list within w_scheduled_service_history
integer x = 215
integer y = 152
integer width = 2491
integer height = 1376
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_fn_scheduled_service_history"
boolean vscrollbar = true
end type

event selected;call super::selected;long ll_patient_workplan_item_id

ll_patient_workplan_item_id = object.patient_workplan_item_id[selected_row]

service_list.display_service_properties(ll_patient_workplan_item_id)

clear_selected()

end event

type cb_ok from commandbutton within w_scheduled_service_history
integer x = 2409
integer y = 1572
integer width = 443
integer height = 124
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;close(parent)

end event

