HA$PBExportHeader$u_report_prefs.sru
forward
global type u_report_prefs from u_tab_manager
end type
end forward

global type u_report_prefs from u_tab_manager
boolean multiline = true
end type
global u_report_prefs u_report_prefs

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();Long		ll_rowcount,ll_row
String 	ls_report_type,ls_description

u_ds_data			report_types

if page_count > 0 Then return page_count
report_types = create u_ds_data
report_types.set_dataobject("dw_report_type_list")
report_types.settransobject(sqlca)
ll_rowcount = report_types.retrieve()
If not tf_check() then return -1

For ll_row = 1 to ll_rowcount
	ls_description = report_types.object.description[ll_row]
	ls_report_type = report_types.object.report_type[ll_row]
//	open_page("u_reports_edit", 0, ls_description, ls_report_type)
Next
//open_page("u_reports_edit", 0, "Miscellaneous", ls_null)
destroy report_types

Return 1
end function

