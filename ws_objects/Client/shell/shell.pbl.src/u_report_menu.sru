$PBExportHeader$u_report_menu.sru
forward
global type u_report_menu from userobject
end type
type dw_report_list from u_dw_pick_list within u_report_menu
end type
end forward

global type u_report_menu from userobject
integer width = 2322
integer height = 1516
long backcolor = 33538240
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_report_list dw_report_list
end type
global u_report_menu u_report_menu

type variables
string report_type


end variables

forward prototypes
public function integer initialize (string ps_report_type)
end prototypes

public function integer initialize (string ps_report_type);long ll_rows

report_type = ps_report_type

dw_report_list.settransobject(sqlca)

ll_rows = dw_report_list.retrieve(report_type)

if ll_rows < 0 then return -1

if ll_rows = 0 then return 0

return 1


end function

on u_report_menu.create
this.dw_report_list=create dw_report_list
this.Control[]={this.dw_report_list}
end on

on u_report_menu.destroy
destroy(this.dw_report_list)
end on

type dw_report_list from u_dw_pick_list within u_report_menu
integer y = 4
integer width = 2313
integer height = 1500
integer taborder = 10
string dataobject = "report_list"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;///////////////////////////////////////////////////////////////////////////////////////////
//
//	Return: none
//
//	Description: Choose a report to configure parameters
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/01/99
//
// Modified By:															Modified On:
////////////////////////////////////////////////////////////////////////////////////////////
String							ls_report_id
Integer							li_sts
str_attributes lstr_attributes

// get the current report id
ls_report_id = dw_report_list.object.report_id[selected_row]

lstr_attributes.attribute_count = 1
lstr_attributes.attribute[1].attribute = "REPORT_ID"
lstr_attributes.attribute[1].value = ls_report_id

li_sts = service_list.do_service("REPORT", lstr_attributes)

clear_selected()

end event

