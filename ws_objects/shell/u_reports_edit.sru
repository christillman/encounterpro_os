HA$PBExportHeader$u_reports_edit.sru
forward
global type u_reports_edit from u_tabpage
end type
type st_page from statictext within u_reports_edit
end type
type pb_down from u_picture_button within u_reports_edit
end type
type pb_up from u_picture_button within u_reports_edit
end type
type st_title from statictext within u_reports_edit
end type
type dw_report_list from u_dw_pick_list within u_reports_edit
end type
end forward

global type u_reports_edit from u_tabpage
integer width = 2098
boolean border = false
st_page st_page
pb_down pb_down
pb_up pb_up
st_title st_title
dw_report_list dw_report_list
end type
global u_reports_edit u_reports_edit

type variables
string report_type
end variables

forward prototypes
public subroutine edit_report (string ps_report_id)
public function integer initialize ()
public subroutine preferred_report (string ps_report_id)
public subroutine report_menu (long pl_row)
public function integer setup_report (string ps_report_id)
public subroutine delete_report (string ps_report_id)
public subroutine redisplay ()
end prototypes

public subroutine edit_report (string ps_report_id);str_popup popup


popup.data_row_count = 1
popup.items[1] = ps_report_id
openwithparm(w_report_definition, popup)


redisplay()

end subroutine

public function integer initialize ();report_type = tag
if report_type = "" then setnull(report_type)

dw_report_list.height = height - dw_report_list.y - 20

st_title.text = text + " Reports"

if isnull(report_type) then dw_report_list.dataobject = "dw_report_list_null_type"

dw_report_list.settransobject(sqlca)

return 1


end function

public subroutine preferred_report (string ps_report_id);

 DECLARE lsp_set_preferred_report PROCEDURE FOR dbo.sp_set_preferred_report  
         @ps_report_type = :report_type,   
         @ps_report_id = :ps_report_id  ;



EXECUTE lsp_set_preferred_report;
if not tf_check() then return

redisplay()


end subroutine

public subroutine report_menu (long pl_row);str_popup				popup
str_popup_return		popup_return
String					buttons[]
Integer					button_pressed, li_sts, li_service_count
window					lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_report_id
string ls_temp

ls_report_id = dw_report_list.object.report_id[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Report Configuration"
	popup.button_titles[popup.button_count] = "Configure Report"
	buttons[popup.button_count] = "SETUP"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "buttonxr.bmp"
	popup.button_helps[popup.button_count] = "Set as Preferred Report"
	popup.button_titles[popup.button_count] = "Preferred Report"
	buttons[popup.button_count] = "PREFER"
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
	CASE "SETUP"
		setup_report(ls_report_id)
	CASE "PREFER"
		preferred_report(ls_report_id)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer setup_report (string ps_report_id);///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ 0 - No reports to configure , 1 - success ]
//
//	Description: Choose a report to configure parameters
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/01/99
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////
u_component_report			luo_report
String							ls_component_id
Integer							li_return

// get the component id
SELECT component_id
	INTO :ls_component_id
	FROM c_Report_Definition
	WHERE report_id = :ps_report_id; 

If Not tf_check() Then Return -1
// If any component defined for selected report then

If Not Isnull(ls_component_id) Or Len(ls_component_id) > 0 Then
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		log.log(This, "u_report_edit", "Error getting report component (" + &
					ls_component_id + ")", 4)
		Return -1
	End If
	If Not Isnull(ps_report_id) Or Len(ps_report_id) > 0 Then
		li_return = luo_report.setupreport(ps_report_id)
		If li_return = 0 Then
			return 0
		End If
		component_manager.destroy_component(luo_report)
	Else
		log.log(This, "u_report_edit", "Invalid report id ("+ps_report_id+")", 4)
		Return -1
	End If
End If
Return 1
end function

public subroutine delete_report (string ps_report_id);

 DECLARE lsp_delete_report PROCEDURE FOR dbo.sp_delete_report  
         @ps_report_id = :ps_report_id  ;


EXECUTE lsp_delete_report;
if not tf_check() then return

redisplay()

end subroutine

public subroutine redisplay ();long ll_rows

if isnull(report_type) then
	ll_rows = dw_report_list.retrieve()
else
	ll_rows = dw_report_list.retrieve(report_type)
end if
If	ll_rows > 0 Then
	dw_report_list.set_page(1, st_page.text)
	If dw_report_list.last_page > 1 then
		pb_up.visible = true
		pb_down.visible = true
		st_page.visible = true
	End If
End If
end subroutine

on u_reports_edit.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_title=create st_title
this.dw_report_list=create dw_report_list
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.dw_report_list
end on

on u_reports_edit.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_title)
destroy(this.dw_report_list)
end on

type st_page from statictext within u_reports_edit
boolean visible = false
integer x = 1797
integer y = 148
integer width = 256
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_down from u_picture_button within u_reports_edit
boolean visible = false
integer x = 1819
integer y = 396
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

type pb_up from u_picture_button within u_reports_edit
boolean visible = false
integer x = 1824
integer y = 244
integer width = 137
integer height = 116
integer taborder = 20
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

type st_title from statictext within u_reports_edit
integer x = 23
integer y = 16
integer width = 2267
integer height = 92
integer textsize = -16
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Reports"
boolean focusrectangle = false
end type

type dw_report_list from u_dw_pick_list within u_reports_edit
integer x = 14
integer y = 112
integer width = 1746
integer height = 1364
integer taborder = 10
string dataobject = "dw_report_list"
boolean border = false
end type

event post_click;//Configure the report ..
String 					ls_report_id,ls_component_id
integer					li_return
u_component_report	luo_report

ls_component_id = object.component_id[clicked_row]
ls_report_id = object.report_id[clicked_row]

If Not Isnull(ls_component_id) Or Len(ls_component_id) > 0 Then
	luo_report = component_manager.get_component(ls_component_id)
	If Isnull(luo_report) Then
		log.log(This, "u_report_edit", "Error getting report component (" + &
					ls_component_id + ")", 4)
		Return 
	End If
	If Not Isnull(ls_report_id) Or Len(ls_report_id) > 0 Then
		li_return = luo_report.setupreport(ls_report_id)
	Else
		log.log(This, "u_report_edit", "Invalid report id ("+ls_report_id+")", 4)
	End If
component_manager.destroy_component(luo_report)
End If

Return
end event

