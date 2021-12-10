$PBExportHeader$u_cpr_page_maintenance.sru
forward
global type u_cpr_page_maintenance from u_soap_page_base_large
end type
type pb_down from picturebutton within u_cpr_page_maintenance
end type
type pb_up from picturebutton within u_cpr_page_maintenance
end type
type dw_schedule from u_dw_pick_list within u_cpr_page_maintenance
end type
type st_hm_title from statictext within u_cpr_page_maintenance
end type
type st_page from statictext within u_cpr_page_maintenance
end type
end forward

global type u_cpr_page_maintenance from u_soap_page_base_large
pb_down pb_down
pb_up pb_up
dw_schedule dw_schedule
st_hm_title st_hm_title
st_page st_page
end type
global u_cpr_page_maintenance u_cpr_page_maintenance

type variables

end variables

forward prototypes
public subroutine xx_initialize ()
public subroutine prev_encounter ()
public subroutine next_encounter ()
public subroutine key_down (keycode key, unsignedlong keyflags)
public subroutine xx_refresh ()
public subroutine xx_refresh_tab ()
end prototypes

public subroutine xx_initialize ();integer i
string ls_temp

pb_up.visible = false
pb_down.visible = false

this_section.load_params(this_section.page[this_page].page_id)

if dw_encounters.visible then
	pb_up.visible = true
	pb_down.visible = true

	pb_down.x = content_right_edge - pb_down.width
	pb_up.x = pb_down.x - pb_up.width - 12
	
	pb_up.y = content_bottom_edge - pb_up.height
	pb_down.y = content_bottom_edge - pb_down.height

	st_page.x = pb_up.x - st_page.width - 8
	st_page.y = pb_up.y

	dw_schedule.x = content_left_edge
	dw_schedule.y = content_top_edge
	dw_schedule.width = content_width
	dw_schedule.height = content_bottom_edge - dw_schedule.y
	
	dw_schedule.object.description.width = dw_schedule.width - 500

	st_hm_title.x = content_left_edge
	st_hm_title.y = dw_schedule.y - st_hm_title.height
	
	dw_schedule.settransobject(sqlca)
else
	pb_up.visible = false
	pb_down.visible = false
end if

refresh()

end subroutine

public subroutine prev_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait

if isnull(current_display_encounter) then return

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 1  then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row - 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)

end subroutine

public subroutine next_encounter ();string ls_find
long ll_count
long ll_encounter_id
long ll_row
integer li_sts
integer li_please_wait


if isnull(current_display_encounter) then return

ll_count = dw_encounters.rowcount()
ls_find = "encounter_id=" + string(current_display_encounter.encounter_id)
ll_row = dw_encounters.find(ls_find, 1, ll_count)
if ll_row > 0 and ll_row < ll_count then
	ll_encounter_id = dw_encounters.object.encounter_id[ll_row + 1]
end if

li_sts = f_set_current_encounter(ll_encounter_id)

li_please_wait = f_please_wait_open()

refresh()

f_please_wait_close(li_please_wait)
end subroutine

public subroutine key_down (keycode key, unsignedlong keyflags);

CHOOSE CASE key
	CASE keyuparrow!
		prev_encounter()
	CASE keydownarrow!
		next_encounter()
	CASE keypageup!
		pb_up.event post clicked()
	CASE keypagedown!
		pb_down.event post clicked()
END CHOOSE

return

end subroutine

public subroutine xx_refresh ();integer li_count
long ll_page

ll_page = dw_schedule.current_page
if ll_page <= 0 then ll_page = 1

li_count = dw_schedule.retrieve(current_patient.cpr_id)
dw_schedule.set_page(ll_page, pb_up, pb_down, st_page)

refresh_tab()

end subroutine

public subroutine xx_refresh_tab ();long i, ll_count
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

on u_cpr_page_maintenance.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.dw_schedule=create dw_schedule
this.st_hm_title=create st_hm_title
this.st_page=create st_page
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.dw_schedule
this.Control[iCurrent+4]=this.st_hm_title
this.Control[iCurrent+5]=this.st_page
end on

on u_cpr_page_maintenance.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.dw_schedule)
destroy(this.st_hm_title)
destroy(this.st_page)
end on

type cb_configure_tab from u_soap_page_base_large`cb_configure_tab within u_cpr_page_maintenance
end type

type st_coding_title from u_soap_page_base_large`st_coding_title within u_cpr_page_maintenance
end type

type st_all from u_soap_page_base_large`st_all within u_cpr_page_maintenance
end type

type st_indirect from u_soap_page_base_large`st_indirect within u_cpr_page_maintenance
end type

type st_direct from u_soap_page_base_large`st_direct within u_cpr_page_maintenance
end type

type st_button_12 from u_soap_page_base_large`st_button_12 within u_cpr_page_maintenance
end type

type st_button_9 from u_soap_page_base_large`st_button_9 within u_cpr_page_maintenance
end type

type st_button_7 from u_soap_page_base_large`st_button_7 within u_cpr_page_maintenance
end type

type st_button_11 from u_soap_page_base_large`st_button_11 within u_cpr_page_maintenance
end type

type st_button_10 from u_soap_page_base_large`st_button_10 within u_cpr_page_maintenance
end type

type st_button_8 from u_soap_page_base_large`st_button_8 within u_cpr_page_maintenance
end type

type pb_12 from u_soap_page_base_large`pb_12 within u_cpr_page_maintenance
end type

type pb_11 from u_soap_page_base_large`pb_11 within u_cpr_page_maintenance
end type

type pb_10 from u_soap_page_base_large`pb_10 within u_cpr_page_maintenance
end type

type pb_9 from u_soap_page_base_large`pb_9 within u_cpr_page_maintenance
end type

type pb_8 from u_soap_page_base_large`pb_8 within u_cpr_page_maintenance
end type

type pb_7 from u_soap_page_base_large`pb_7 within u_cpr_page_maintenance
end type

type dw_encounters from u_soap_page_base_large`dw_encounters within u_cpr_page_maintenance
end type

type cb_coding from u_soap_page_base_large`cb_coding within u_cpr_page_maintenance
end type

type pb_4 from u_soap_page_base_large`pb_4 within u_cpr_page_maintenance
end type

type cb_current from u_soap_page_base_large`cb_current within u_cpr_page_maintenance
end type

type pb_1 from u_soap_page_base_large`pb_1 within u_cpr_page_maintenance
end type

type pb_5 from u_soap_page_base_large`pb_5 within u_cpr_page_maintenance
end type

type pb_2 from u_soap_page_base_large`pb_2 within u_cpr_page_maintenance
end type

type pb_3 from u_soap_page_base_large`pb_3 within u_cpr_page_maintenance
end type

type pb_6 from u_soap_page_base_large`pb_6 within u_cpr_page_maintenance
end type

type st_button_1 from u_soap_page_base_large`st_button_1 within u_cpr_page_maintenance
end type

type st_button_2 from u_soap_page_base_large`st_button_2 within u_cpr_page_maintenance
end type

type st_button_3 from u_soap_page_base_large`st_button_3 within u_cpr_page_maintenance
end type

type st_button_4 from u_soap_page_base_large`st_button_4 within u_cpr_page_maintenance
end type

type st_button_5 from u_soap_page_base_large`st_button_5 within u_cpr_page_maintenance
end type

type st_button_6 from u_soap_page_base_large`st_button_6 within u_cpr_page_maintenance
end type

type st_config_mode_menu from u_soap_page_base_large`st_config_mode_menu within u_cpr_page_maintenance
end type

type st_encounter_count from u_soap_page_base_large`st_encounter_count within u_cpr_page_maintenance
end type

type st_7 from u_soap_page_base_large`st_7 within u_cpr_page_maintenance
end type

type st_no_encounters from u_soap_page_base_large`st_no_encounters within u_cpr_page_maintenance
end type

type pb_down from picturebutton within u_cpr_page_maintenance
integer x = 2994
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text

if dw_schedule.current_page >= dw_schedule.last_page then return

dw_schedule.set_page(dw_schedule.current_page + 1, ls_text)
pb_up.enabled = true

if dw_schedule.current_page >= dw_schedule.last_page then
	enabled = false
else
	enabled = true
end if

end event

type pb_up from picturebutton within u_cpr_page_maintenance
integer x = 2834
integer y = 2008
integer width = 137
integer height = 116
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
alignment htextalign = left!
end type

event clicked;string ls_text

if dw_schedule.current_page <= 1 then return

dw_schedule.set_page(dw_schedule.current_page - 1, ls_text)
pb_down.enabled = true

if dw_schedule.current_page <= 1 then
	enabled = false
else
	enabled = true
end if

end event

type dw_schedule from u_dw_pick_list within u_cpr_page_maintenance
integer x = 1143
integer y = 144
integer width = 1989
integer height = 1844
integer taborder = 30
boolean bringtotop = true
string dataobject = "dw_patient_maintenance"
end type

event selected;call super::selected;str_service_info lstr_service

lstr_service.service = "Maintenance Rule Status"

f_attribute_add_attribute(lstr_service.attributes, "maintenance_rule_id", string(object.maintenance_rule_id[selected_row]))

service_list.do_service(lstr_service)

clear_selected()

end event

type st_hm_title from statictext within u_cpr_page_maintenance
integer x = 1147
integer y = 24
integer width = 1070
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Health Maintenance Schedule"
boolean focusrectangle = false
end type

type st_page from statictext within u_cpr_page_maintenance
boolean visible = false
integer x = 2560
integer y = 2008
integer width = 256
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean focusrectangle = false
end type

