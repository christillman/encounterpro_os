$PBExportHeader$w_pick_result_severity.srw
forward
global type w_pick_result_severity from w_window_base
end type
type dw_severity from u_dw_pick_list within w_pick_result_severity
end type
type st_title from statictext within w_pick_result_severity
end type
type pb_cancel from u_picture_button within w_pick_result_severity
end type
type pb_done from u_picture_button within w_pick_result_severity
end type
type st_ordered_title from statictext within w_pick_result_severity
end type
type pb_1 from u_pb_help_button within w_pick_result_severity
end type
end forward

global type w_pick_result_severity from w_window_base
integer x = 503
integer y = 224
integer width = 1783
integer height = 1372
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = COLOR_BACKGROUND
dw_severity dw_severity
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
st_ordered_title st_ordered_title
pb_1 pb_1
end type
global w_pick_result_severity w_pick_result_severity

type variables
string cpr_id
long encounter_id
string treatment_type

string observation_type

end variables

on w_pick_result_severity.create
int iCurrent
call super::create
this.dw_severity=create dw_severity
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.st_ordered_title=create st_ordered_title
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_severity
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.pb_cancel
this.Control[iCurrent+4]=this.pb_done
this.Control[iCurrent+5]=this.st_ordered_title
this.Control[iCurrent+6]=this.pb_1
end on

on w_pick_result_severity.destroy
call super::destroy
destroy(this.dw_severity)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.st_ordered_title)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_find
long ll_row

popup = message.powerobjectparm
if popup.data_row_count < 0 or popup.data_row_count > 1 then
	log.log(this, "w_pick_result_severity:open", "Invalid Parameters", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
end if

dw_severity.settransobject(sqlca)
li_sts = dw_severity.retrieve("RESULTSEVERITY")
if li_sts < 0 then
	log.log(this, "w_pick_result_severity:open", "Error retrieving severities", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
elseif li_sts = 0 then
	log.log(this, "w_pick_result_severity:open", "No severities found", 4)
	popup_return.item_count = 0
	closewithreturn(this, popup_return)
	return
else
	if popup.data_row_count = 1 then
		if not isnull(popup.items[1]) then
			ls_find = "domain_item='" + popup.items[1] + "'"
			ll_row = dw_severity.find(ls_find, 1 , dw_severity.rowcount())
			if ll_row > 0 then
				dw_severity.object.selected_flag[ll_row] = 1
			end if
		end if
	end if
end if



end event

type dw_severity from u_dw_pick_list within w_pick_result_severity
integer x = 498
integer y = 340
integer width = 782
integer height = 956
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_domain_pick_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;str_popup_return popup_return
string ls_domain_item
string ls_domain_item_description

ls_domain_item = object.domain_item[lastrow]
ls_domain_item_description = object.domain_item_description[lastrow]

if isnull(ls_domain_item) then return

popup_return.item_count = 1
popup_return.items[1] = ls_domain_item
popup_return.descriptions[1] = ls_domain_item_description

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_pick_result_severity
integer x = 5
integer width = 1765
integer height = 112
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
string text = "Followup Severity"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pick_result_severity
boolean visible = false
integer x = 91
integer y = 1084
integer taborder = 30
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_pick_result_severity
integer x = 1394
integer y = 1088
integer taborder = 10
boolean bringtotop = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return
long ll_row

popup_return.item_count = 1

ll_row = dw_severity.get_selected_row()
if ll_row <= 0 then
	setnull(popup_return.items[1])
	popup_return.descriptions[1] = "N/A"
else
	popup_return.items[1] = dw_severity.object.domain_item[ll_row]
	popup_return.descriptions[1] = dw_severity.object.domain_item_description[ll_row]
end if

closewithreturn(parent, popup_return)


end event

type st_ordered_title from statictext within w_pick_result_severity
integer x = 146
integer y = 152
integer width = 1486
integer height = 152
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
string text = "Select the minimum result severity which will cause the followup observation to display"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_help_button within w_pick_result_severity
integer x = 123
integer y = 1136
integer taborder = 20
boolean bringtotop = true
end type

