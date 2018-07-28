$PBExportHeader$u_tab_patient_data.sru
forward
global type u_tab_patient_data from u_tab_manager
end type
type tabpage_general from u_tabpage_patient_data within u_tab_patient_data
end type
type tabpage_general from u_tabpage_patient_data within u_tab_patient_data
end type
type tabpage_alias from u_tabpage_patient_alias within u_tab_patient_data
end type
type tabpage_alias from u_tabpage_patient_alias within u_tab_patient_data
end type
type tabpage_communication from u_tabpage_patient_communication within u_tab_patient_data
end type
type tabpage_communication from u_tabpage_patient_communication within u_tab_patient_data
end type
type tabpage_care_team from u_tabpage_patient_care_team within u_tab_patient_data
end type
type tabpage_care_team from u_tabpage_patient_care_team within u_tab_patient_data
end type
type tabpage_followups from u_tabpage_patient_rtf within u_tab_patient_data
end type
type tabpage_followups from u_tabpage_patient_rtf within u_tab_patient_data
end type
type tabpage_referrals from u_tabpage_patient_rtf within u_tab_patient_data
end type
type tabpage_referrals from u_tabpage_patient_rtf within u_tab_patient_data
end type
type tabpage_relations from u_tabpage_patient_relations within u_tab_patient_data
end type
type tabpage_relations from u_tabpage_patient_relations within u_tab_patient_data
end type
type tabpage_authority from u_tabpage_patient_authority within u_tab_patient_data
end type
type tabpage_authority from u_tabpage_patient_authority within u_tab_patient_data
end type
type tabpage_patient_employer from u_tabpage_patient_employer within u_tab_patient_data
end type
type tabpage_patient_employer from u_tabpage_patient_employer within u_tab_patient_data
end type
type tabpage_encounters from u_tabpage_patient_encounters within u_tab_patient_data
end type
type tabpage_encounters from u_tabpage_patient_encounters within u_tab_patient_data
end type
type tabpage_documents from u_tabpage_documents within u_tab_patient_data
end type
type tabpage_documents from u_tabpage_documents within u_tab_patient_data
end type
type tabpage_ids from u_tabpage_patient_ids within u_tab_patient_data
end type
type tabpage_ids from u_tabpage_patient_ids within u_tab_patient_data
end type
type tabpage_user_defined from u_tabpage_patient_user_defined within u_tab_patient_data
end type
type tabpage_user_defined from u_tabpage_patient_user_defined within u_tab_patient_data
end type
end forward

global type u_tab_patient_data from u_tab_manager
integer width = 3072
integer height = 1376
boolean boldselectedtext = true
tabpage_general tabpage_general
tabpage_alias tabpage_alias
tabpage_communication tabpage_communication
tabpage_care_team tabpage_care_team
tabpage_followups tabpage_followups
tabpage_referrals tabpage_referrals
tabpage_relations tabpage_relations
tabpage_authority tabpage_authority
tabpage_patient_employer tabpage_patient_employer
tabpage_encounters tabpage_encounters
tabpage_documents tabpage_documents
tabpage_ids tabpage_ids
tabpage_user_defined tabpage_user_defined
end type
global u_tab_patient_data u_tab_patient_data

on u_tab_patient_data.create
this.tabpage_general=create tabpage_general
this.tabpage_alias=create tabpage_alias
this.tabpage_communication=create tabpage_communication
this.tabpage_care_team=create tabpage_care_team
this.tabpage_followups=create tabpage_followups
this.tabpage_referrals=create tabpage_referrals
this.tabpage_relations=create tabpage_relations
this.tabpage_authority=create tabpage_authority
this.tabpage_patient_employer=create tabpage_patient_employer
this.tabpage_encounters=create tabpage_encounters
this.tabpage_documents=create tabpage_documents
this.tabpage_ids=create tabpage_ids
this.tabpage_user_defined=create tabpage_user_defined
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_general
this.Control[iCurrent+2]=this.tabpage_alias
this.Control[iCurrent+3]=this.tabpage_communication
this.Control[iCurrent+4]=this.tabpage_care_team
this.Control[iCurrent+5]=this.tabpage_followups
this.Control[iCurrent+6]=this.tabpage_referrals
this.Control[iCurrent+7]=this.tabpage_relations
this.Control[iCurrent+8]=this.tabpage_authority
this.Control[iCurrent+9]=this.tabpage_patient_employer
this.Control[iCurrent+10]=this.tabpage_encounters
this.Control[iCurrent+11]=this.tabpage_documents
this.Control[iCurrent+12]=this.tabpage_ids
this.Control[iCurrent+13]=this.tabpage_user_defined
end on

on u_tab_patient_data.destroy
call super::destroy
destroy(this.tabpage_general)
destroy(this.tabpage_alias)
destroy(this.tabpage_communication)
destroy(this.tabpage_care_team)
destroy(this.tabpage_followups)
destroy(this.tabpage_referrals)
destroy(this.tabpage_relations)
destroy(this.tabpage_authority)
destroy(this.tabpage_patient_employer)
destroy(this.tabpage_encounters)
destroy(this.tabpage_documents)
destroy(this.tabpage_ids)
destroy(this.tabpage_user_defined)
end on

type tabpage_general from u_tabpage_patient_data within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "General Info"
end type

type tabpage_alias from u_tabpage_patient_alias within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Alias"
end type

type tabpage_communication from u_tabpage_patient_communication within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Comm"
end type

type tabpage_care_team from u_tabpage_patient_care_team within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Care Team"
end type

type tabpage_followups from u_tabpage_patient_rtf within u_tab_patient_data
boolean visible = false
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Appointments"
end type

type tabpage_referrals from u_tabpage_patient_rtf within u_tab_patient_data
boolean visible = false
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Referrals"
end type

type tabpage_relations from u_tabpage_patient_relations within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Relations"
end type

type tabpage_authority from u_tabpage_patient_authority within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Insurance"
end type

type tabpage_patient_employer from u_tabpage_patient_employer within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Employment Info"
end type

type tabpage_encounters from u_tabpage_patient_encounters within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Open Encounters"
end type

type tabpage_documents from u_tabpage_documents within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "Documents"
end type

type tabpage_ids from u_tabpage_patient_ids within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "External IDs"
end type

type tabpage_user_defined from u_tabpage_patient_user_defined within u_tab_patient_data
integer x = 18
integer y = 112
integer width = 3035
integer height = 1248
string text = "User Defined"
end type

