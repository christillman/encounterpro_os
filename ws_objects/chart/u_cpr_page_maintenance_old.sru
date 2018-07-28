HA$PBExportHeader$u_cpr_page_maintenance_old.sru
forward
global type u_cpr_page_maintenance_old from u_cpr_page_base
end type
type st_title from statictext within u_cpr_page_maintenance_old
end type
type cb_page from commandbutton within u_cpr_page_maintenance_old
end type
type dw_schedule from u_dw_pick_list within u_cpr_page_maintenance_old
end type
type st_maint_title from statictext within u_cpr_page_maintenance_old
end type
type st_date_title from statictext within u_cpr_page_maintenance_old
end type
end forward

global type u_cpr_page_maintenance_old from u_cpr_page_base
st_title st_title
cb_page cb_page
dw_schedule dw_schedule
st_maint_title st_maint_title
st_date_title st_date_title
end type
global u_cpr_page_maintenance_old u_cpr_page_maintenance_old

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
public subroutine losefocus ()
public subroutine refresh_tab ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

st_title.width = width
dw_schedule.x = (width - dw_schedule.width)/2
cb_page.x = dw_schedule.x + dw_schedule.width + 30
st_maint_title.x = dw_schedule.x
st_date_title.x = dw_schedule.x + dw_schedule.width - st_date_title.width

dw_schedule.settransobject(sqlca)

refresh()

end subroutine

public subroutine refresh ();integer li_count

li_count = dw_schedule.retrieve(current_patient.cpr_id)
if li_count <= 0 then
	cb_page.visible = false
else
	dw_schedule.set_page(1, cb_page.text)
end if

refresh_tab()

end subroutine

public subroutine losefocus ();refresh_tab()

end subroutine

public subroutine refresh_tab ();long i, ll_count
datetime ldt_schedule_date
integer li_max_status
datetime ldt_today
integer li_status
long ll_warning_days

ldt_today = datetime(today(), now())

ll_count = dw_schedule.rowcount()
li_max_status = 1

for i = 1 to ll_count
	// Calculate status of each record
	ldt_schedule_date = dw_schedule.object.schedule_date[i]
	if isnull(ldt_schedule_date) then
		li_status = 3
	elseif ldt_schedule_date < ldt_today then
		li_status = 3
	else
		ll_warning_days = dw_schedule.object.warning_days[i]
		if daysafter(date(ldt_today), date(ldt_schedule_date)) <= ll_warning_days then
			li_status = 2
		else
			li_status = 1
		end if
	end if

	// Update the datawindows
	dw_schedule.object.status[i] = li_status

	// Calculate the max status
	if li_status > li_max_status then li_max_status = li_status
next

if li_max_status = 1 then
	tabtextcolor = COLOR_TEXT_NORMAL
elseif li_max_status = 2 then
	tabtextcolor = COLOR_TEXT_WARNING
else
	tabtextcolor = COLOR_TEXT_ERROR
end if

end subroutine

on u_cpr_page_maintenance_old.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_page=create cb_page
this.dw_schedule=create dw_schedule
this.st_maint_title=create st_maint_title
this.st_date_title=create st_date_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_page
this.Control[iCurrent+3]=this.dw_schedule
this.Control[iCurrent+4]=this.st_maint_title
this.Control[iCurrent+5]=this.st_date_title
end on

on u_cpr_page_maintenance_old.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_page)
destroy(this.dw_schedule)
destroy(this.st_maint_title)
destroy(this.st_date_title)
end on

type st_title from statictext within u_cpr_page_maintenance_old
integer y = 8
integer width = 2853
integer height = 120
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Health Maintenance Schedule"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_page from commandbutton within u_cpr_page_maintenance_old
integer x = 2235
integer y = 212
integer width = 407
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Page 9 of 9"
end type

event clicked;dw_schedule.set_page(dw_schedule.current_page + 1, text)

end event

type dw_schedule from u_dw_pick_list within u_cpr_page_maintenance_old
integer x = 681
integer y = 204
integer width = 1527
integer height = 988
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_patient_maintenance"
boolean border = false
end type

event selected;call super::selected;str_service_info lstr_service

lstr_service.service = "Maintenance Rule Status"

f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(object.maintenance_rule_id[selected_row]))

service_list.do_service(lstr_service)

clear_selected()

end event

type st_maint_title from statictext within u_cpr_page_maintenance_old
integer x = 695
integer y = 132
integer width = 608
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Maintenance Item"
boolean focusrectangle = false
end type

type st_date_title from statictext within u_cpr_page_maintenance_old
integer x = 1787
integer y = 132
integer width = 421
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Maint Date"
alignment alignment = center!
boolean focusrectangle = false
end type

