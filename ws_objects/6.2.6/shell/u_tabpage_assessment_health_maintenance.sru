HA$PBExportHeader$u_tabpage_assessment_health_maintenance.sru
forward
global type u_tabpage_assessment_health_maintenance from u_tabpage
end type
end forward

global type u_tabpage_assessment_health_maintenance from u_tabpage
end type
global u_tabpage_assessment_health_maintenance u_tabpage_assessment_health_maintenance

type variables
boolean allow_editing

string assessment_id

// Fields managed on this tab

end variables

on u_tabpage_assessment_health_maintenance.create
call super::create
end on

on u_tabpage_assessment_health_maintenance.destroy
call super::destroy
end on

