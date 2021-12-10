$PBExportHeader$w_pick_treatment_type.srw
forward
global type w_pick_treatment_type from w_window_base
end type
type dw_observation_type from u_dw_pick_list within w_pick_treatment_type
end type
type dw_treatment_type from u_dw_pick_list within w_pick_treatment_type
end type
type st_2 from statictext within w_pick_treatment_type
end type
type st_3 from statictext within w_pick_treatment_type
end type
type cb_cancel from commandbutton within w_pick_treatment_type
end type
type st_title from statictext within w_pick_treatment_type
end type
end forward

global type w_pick_treatment_type from w_window_base
integer x = 128
integer y = 152
integer width = 2587
integer height = 1576
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_observation_type dw_observation_type
dw_treatment_type dw_treatment_type
st_2 st_2
st_3 st_3
cb_cancel cb_cancel
st_title st_title
end type
global w_pick_treatment_type w_pick_treatment_type

on w_pick_treatment_type.create
int iCurrent
call super::create
this.dw_observation_type=create dw_observation_type
this.dw_treatment_type=create dw_treatment_type
this.st_2=create st_2
this.st_3=create st_3
this.cb_cancel=create cb_cancel
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_observation_type
this.Control[iCurrent+2]=this.dw_treatment_type
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.st_title
end on

on w_pick_treatment_type.destroy
call super::destroy
destroy(this.dw_observation_type)
destroy(this.dw_treatment_type)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_cancel)
destroy(this.st_title)
end on

event open;call super::open;string ls_null
long ll_count
long ll_row
string ls_find
string ls_title

setnull(ls_null)

ls_title = message.stringparm
if len(ls_title) > 0 then
	st_title.text = "Select Treatment Type for " + ls_title
else
	st_title.text = "Select Treatment Type"
end if

dw_observation_type.settransobject(sqlca)
dw_treatment_type.settransobject(sqlca)


ll_count = dw_observation_type.retrieve()
if ll_count <= 0 then
	log.log(this, "w_pick_treatment_type:open", "error getting observation types", 4)
	closewithreturn(this, ls_null)
	return
end if

ls_find = "lower(observation_type) = 'lab/test'"
ll_row = dw_observation_type.find(ls_find, 1, ll_count)
if isnull(ll_row) or ll_row <= 0 then ll_row = 1

dw_observation_type.object.selected_flag[ll_row] = 1
dw_observation_type.event POST selected(ll_row)


end event

type pb_epro_help from w_window_base`pb_epro_help within w_pick_treatment_type
integer x = 891
integer y = 1396
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_treatment_type
end type

type dw_observation_type from u_dw_pick_list within w_pick_treatment_type
integer x = 133
integer y = 284
integer width = 901
integer height = 1036
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_observation_type_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_observation_type

ls_observation_type = object.observation_type[selected_row]

dw_treatment_type.retrieve(ls_observation_type)


end event

type dw_treatment_type from u_dw_pick_list within w_pick_treatment_type
integer x = 1193
integer y = 284
integer width = 1257
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_treatment_type_by_observation_type"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_treatment_type

ls_treatment_type = object.treatment_type[selected_row]

closewithreturn(parent, ls_treatment_type)


end event

type st_2 from statictext within w_pick_treatment_type
integer x = 146
integer y = 212
integer width = 800
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
string text = "Observation Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pick_treatment_type
integer x = 1344
integer y = 212
integer width = 850
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
string text = "Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_pick_treatment_type
integer x = 64
integer y = 1388
integer width = 402
integer height = 120
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;string ls_null

setnull(ls_null)

closewithreturn(parent, ls_null)

end event

type st_title from statictext within w_pick_treatment_type
integer width = 2578
integer height = 200
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Select Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

