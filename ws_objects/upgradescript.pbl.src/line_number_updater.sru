$PBExportHeader$line_number_updater.sru
forward
global type line_number_updater from nonvisualobject
end type
end forward

global type line_number_updater from nonvisualobject
end type
global line_number_updater line_number_updater

forward prototypes
public function integer update_line_numbers ()
public function string pbl_path (string ps_pbl)
public subroutine parse_log_line (string ps_line_content, ref string ps_pbl, ref string ps_source_file, ref string ps_script_name, ref string ps_line_number)
public function string filepath (string ps_pbl_path, string ps_script_name)
end prototypes

public function integer update_line_numbers ();
string ls_fullpath, ls_filename, ls_line_content, ls_script_line
integer li_rc, li_dotidx, li_quoteidx
long ll_input, ll_script
long ll_read, ll_read_script
string ls_pbl, ls_pbl_path, ls_source_file, ls_script_name, ls_line_number
string ls_source_file_prev
string ls_quotes[]
string ls_subfile, ls_script_sub_line

string ls_src_path = "C:\EncounterPro\encounterpro_os\ws_objects\Client\"

GetFileOpenName ("log.log file", ls_fullpath, ls_filename)

IF li_rc = 0 THEN
	ll_input = FileOpen(ls_fullpath, LineMode!)
	if ll_input < 0 then
		MessageBox("File could not be opened", ls_fullpath)
	else
		ll_read = FileReadEx(ll_input, ls_line_content)
		parse_log_line(ls_line_content, ls_pbl, ls_source_file, ls_script_name, ls_line_number)
		ls_source_file_prev = ""
		ls_subfile = ""
		do while ll_read >= 0 
			
			if ls_source_file <> ls_source_file_prev then
				if ls_source_file_prev <> "" then
					FileClose(ll_script)
					ls_filename = filepath(ls_pbl_path, ls_source_file_prev)
					ll_script = FileOpen(ls_filename, TextMode!, Write!, LockWrite!, Replace!)
					FileWriteEx(ll_script, ls_subfile)
					FileClose(ll_script)
					ls_subfile = ""
				end if
				ls_pbl_path = ls_src_path + pbl_path(ls_pbl)
				ls_filename = filepath(ls_pbl_path, ls_source_file)
				ll_script = FileOpen(ls_filename, LineMode!)
				if ll_script < 0 then
					Clipboard(ls_filename)
					MessageBox("File not found", ls_filename)
				end if
				ls_source_file_prev = ls_source_file
			end if
			ll_read_script = FileReadEx(ll_script, ls_script_line)
			do while ll_read_script >= 0 
				if Pos(ls_script_line, "log.log") = 0 then 
					ls_subfile += ls_script_line + "~r~n"
				else
					f_split(ls_script_line, '"', ls_quotes)
					ls_script_sub_line = ls_quotes[1] + '"'
					if ls_source_file = ls_script_name then
						ls_script_sub_line += ls_script_name + ":" + ls_line_number + '"'
					else
						ls_script_sub_line += ls_source_file + "." + ls_script_name + ":" + ls_line_number + '"'
					end if
					for li_quoteidx = 3 to upperbound(ls_quotes) - 1
						ls_script_sub_line += ls_quotes[li_quoteidx] + '"'
					next
					ls_script_sub_line += ls_quotes[upperbound(ls_quotes)]
					ls_subfile += ls_script_sub_line + "~r~n"
					// get the next match line from the log file
					ll_read = FileReadEx(ll_input, ls_line_content)
					parse_log_line(ls_line_content, ls_pbl, ls_source_file, ls_script_name, ls_line_number)			
				end if
				ll_read_script = FileReadEx(ll_script, ls_script_line)
			loop
		loop
		FileClose(ll_script)
		// write the last sub
		ls_filename = filepath(ls_pbl_path, ls_source_file_prev)
		ll_script = FileOpen(ls_filename, TextMode!, Write!, LockWrite!, Replace!)
		FileWriteEx(ll_script, ls_subfile)
		FileClose(ll_script)
		
		FileClose(ll_input)
	end if
END IF

RETURN 0

end function

public function string pbl_path (string ps_pbl);

CHOOSE CASE ps_pbl
	CASE 'chart_attachments.pbl', 'chart_browser.pbl', 'chart_drug_history.pbl', 'chart_famhistory.pbl', 'chart_graph.pbl', 'chart_growth.pbl', 'chart_healthmain.pbl', 'chart_labs_tests.pbl', 'chart_proc_history.pbl', 'chart_soap.pbl', 'chart_summary.pbl', 'chart_vaccines.pbl'
		return 'chart\' + ps_pbl + '.src\'
	CASE 'cpr.pbl', 'dbmaint.pbl', 'server.pbl', ''
		return ps_pbl + '.src\'
	CASE 'ext_alert.pbl', 'ext_attachments.pbl', 'ext_billing.pbl', 'ext_coding.pbl', 'ext_msging.pbl', 'ext_nomenclature.pbl', 'ext_observation.pbl', 'ext_pbreports.pbl', 'ext_properties.pbl', 'ext_schedule.pbl', 'ext_xml.pbl'
		return 'extension\' + ps_pbl + '.src\'
	CASE 'server_services.pbl'
		return 'server\' + ps_pbl + '.src\'
	CASE 'svc_activity.pbl', 'svc_billing.pbl', 'svc_browser.pbl', 'svc_chart.pbl', 'svc_chart_encounter.pbl', 'svc_configuration.pbl', 'svc_epro_message.pbl', 'svc_epro_todo.pbl', 'svc_epro_workflow.pbl', 'svc_followup.pbl', 'svc_get_medication.pbl', 'svc_get_officemed.pbl', 'svc_get_referral.pbl', 'svc_get_refills.pbl', 'svc_immunization.pbl', 'svc_maintenance.pbl', 'svc_material.pbl', 'svc_medication.pbl', 'svc_observations.pbl', 'svc_patient_message.pbl', 'svc_procedure.pbl', 'svc_report.pbl', 'svc_utility.pbl'
		return 'service\'  + ps_pbl + '.src\'
	CASE 'chart.pbl', 'clinicaldatacache.pbl', 'common.pbl', 'components.pbl', 'datawindow.pbl', 'eproepiegateway.pbl', 'patient.pbl', 'security.pbl', 'shell.pbl', 'treatments.pbl', 'xml.pbl'
		return 'shell\' + ps_pbl + '.src\'
	CASE ELSE
		return 'pbl not found in pbl_path'
END CHOOSE

end function

public subroutine parse_log_line (string ps_line_content, ref string ps_pbl, ref string ps_source_file, ref string ps_script_name, ref string ps_line_number);
integer li_dotidx
string ls_dots[]
string ls_parens[]

if ps_line_content = "" then return

f_split(ps_line_content, "(", ls_parens)
ps_pbl = ls_parens[1]
ps_source_file = left(ls_parens[2], Pos(ls_parens[2], ')') - 1)
f_split(Mid(ls_parens[2], Pos(ls_parens[2], ')') + 1), ".", ls_dots)
ps_script_name = ls_dots[1]
if ls_dots[1] = "" then
	// global functions have no internal components, so no dots to find;
	// other components have a dot right after the parens (this case)
	ps_script_name = ls_dots[2]
	li_dotidx = 3
	do while Pos(ls_dots[li_dotidx], ":") = 0 
		ps_script_name += "." + ls_dots[li_dotidx]
		li_dotidx = li_dotidx + 1
	loop
	ps_line_number = left(ls_dots[li_dotidx], 4)
else
	ps_script_name = ps_source_file
	ps_line_number = Mid(ls_parens[2], Pos(ls_parens[2], ')') + 1, 4)
end if


end subroutine

public function string filepath (string ps_pbl_path, string ps_script_name);
string ls_ext

CHOOSE CASE left(ps_script_name,1)
	CASE 't'
		// tf_
		ls_ext = 'srf'
	CASE 'n'
		// n_
		ls_ext = 'sru'
	CASE ELSE
		ls_ext = 'sr' + left(ps_script_name,1)
END CHOOSE

RETURN ps_pbl_path + ps_script_name + "." + ls_ext
end function

on line_number_updater.create
call super::create
TriggerEvent( this, "constructor" )
end on

on line_number_updater.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

