HA$PBExportHeader$u_reports_tab.sru
forward
global type u_reports_tab from UserObject
end type
type tab_report_type from tab within u_reports_tab
end type
type tab_report_type from tab within u_reports_tab
end type
end forward

global type u_reports_tab from UserObject
int Width=2423
int Height=1712
boolean Border=true
long BackColor=33538240
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
tab_report_type tab_report_type
end type
global u_reports_tab u_reports_tab

forward prototypes
public subroutine initialize ()
end prototypes

public subroutine initialize ();string ls_report_type
string ls_description
long i
long ll_rows
u_report_menu luo_report_tab
string ls_servername, ls_dbname, ls_dbms, ls_uid, ls_pwd
integer li_sts
u_ds_data luo_data

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_general_report_types")
ll_rows = luo_data.retrieve()

for i = 1 to ll_rows
	ls_report_type = luo_data.object.report_type[i]
	ls_description = luo_data.object.description[i]
	tab_report_type.opentab(luo_report_tab, i)
	luo_report_tab.initialize(ls_report_type)
	luo_report_tab.text = ls_description
next


end subroutine

on u_reports_tab.create
this.tab_report_type=create tab_report_type
this.Control[]={this.tab_report_type}
end on

on u_reports_tab.destroy
destroy(this.tab_report_type)
end on

type tab_report_type from tab within u_reports_tab
int Width=2409
int Height=1700
int TabOrder=10
boolean RaggedRight=true
int SelectedTab=1
long BackColor=79741120
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

