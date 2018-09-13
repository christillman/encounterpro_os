$PBExportHeader$u_soap_page_encounter_notes.sru
$PBExportComments$show button bar for doing test from observation & treatment types..
forward
global type u_soap_page_encounter_notes from u_soap_page_base
end type
type pb_down from picturebutton within u_soap_page_encounter_notes
end type
type pb_up from picturebutton within u_soap_page_encounter_notes
end type
type st_page from statictext within u_soap_page_encounter_notes
end type
type dw_progress_display from u_dw_progress_display within u_soap_page_encounter_notes
end type
end forward

global type u_soap_page_encounter_notes from u_soap_page_base
pb_down pb_down
pb_up pb_up
st_page st_page
dw_progress_display dw_progress_display
end type
global u_soap_page_encounter_notes u_soap_page_encounter_notes

type variables
string abnormal_flag

string progress_type
string progress_key

string progress_value_list[]
integer progress_value_count

end variables

forward prototypes
public subroutine xx_refresh ()
public subroutine xx_refresh_tab ()
public function integer display_progress ()
public subroutine xx_initialize ()
end prototypes

public subroutine xx_refresh ();display_progress()

end subroutine

public subroutine xx_refresh_tab ();display_progress()

end subroutine

public function integer display_progress ();str_progress_list lstr_progress
long ll_count
long i
string ls_who
long ll_row
integer li_sts

dw_progress_display.set_progress_type(progress_type)

dw_progress_display.last_page = 0
dw_progress_display.set_page(1, pb_up, pb_down, st_page)

dw_progress_display.sort = "D"

text = this_section.page[this_page].description + " (" + string(dw_progress_display.rowcount()) + ")"

return 1

end function

public subroutine xx_initialize ();integer i
long ll_dwwidth
integer li_sts

pb_up.visible = false
pb_down.visible = false


this_section.load_params(this_section.page[this_page].page_id)

progress_type = this_section.get_attribute(this_section.page[this_page].page_id, "progress_type")

progress_key = this_section.get_attribute(this_section.page[this_page].page_id, "progress_key")

if st_encounter.visible then
	dw_progress_display.visible = true
	pb_up.x = button_x - pb_up.width - 16
	pb_down.x = pb_up.x
	st_page.x = pb_up.x
	
	dw_progress_display.width = pb_up.x - dw_progress_display.x - 16
	dw_progress_display.height = height - dw_progress_display.y
	ll_dwwidth = dw_progress_display.width - 150
	dw_progress_display.object.attachment_description.width = string(ll_dwwidth / 4)
	dw_progress_display.object.progress.x = string((ll_dwwidth / 4) + 46)
	dw_progress_display.object.progress.width = string((ll_dwwidth * 3) / 4)
else
	dw_progress_display.visible = false
end if

li_sts = dw_progress_display.initialize(current_service, "Encounter")


return

end subroutine

on u_soap_page_encounter_notes.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.dw_progress_display=create dw_progress_display
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.dw_progress_display
end on

on u_soap_page_encounter_notes.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.dw_progress_display)
end on

type cb_coding from u_soap_page_base`cb_coding within u_soap_page_encounter_notes
end type

type st_no_encounters from u_soap_page_base`st_no_encounters within u_soap_page_encounter_notes
end type

type pb_4 from u_soap_page_base`pb_4 within u_soap_page_encounter_notes
end type

type cb_current from u_soap_page_base`cb_current within u_soap_page_encounter_notes
end type

type cb_prev from u_soap_page_base`cb_prev within u_soap_page_encounter_notes
end type

type cb_next from u_soap_page_base`cb_next within u_soap_page_encounter_notes
end type

type pb_1 from u_soap_page_base`pb_1 within u_soap_page_encounter_notes
end type

type pb_5 from u_soap_page_base`pb_5 within u_soap_page_encounter_notes
end type

type pb_2 from u_soap_page_base`pb_2 within u_soap_page_encounter_notes
end type

type pb_3 from u_soap_page_base`pb_3 within u_soap_page_encounter_notes
end type

type pb_6 from u_soap_page_base`pb_6 within u_soap_page_encounter_notes
end type

type pb_summary from u_soap_page_base`pb_summary within u_soap_page_encounter_notes
end type

type st_button_1 from u_soap_page_base`st_button_1 within u_soap_page_encounter_notes
end type

type st_button_2 from u_soap_page_base`st_button_2 within u_soap_page_encounter_notes
end type

type st_button_3 from u_soap_page_base`st_button_3 within u_soap_page_encounter_notes
end type

type st_button_4 from u_soap_page_base`st_button_4 within u_soap_page_encounter_notes
end type

type st_button_5 from u_soap_page_base`st_button_5 within u_soap_page_encounter_notes
end type

type st_button_6 from u_soap_page_base`st_button_6 within u_soap_page_encounter_notes
end type

type st_encounter from u_soap_page_base`st_encounter within u_soap_page_encounter_notes
end type

type st_encounter_background from u_soap_page_base`st_encounter_background within u_soap_page_encounter_notes
end type

type st_config_mode_menu from u_soap_page_base`st_config_mode_menu within u_soap_page_encounter_notes
end type

type st_encounter_status from u_soap_page_base`st_encounter_status within u_soap_page_encounter_notes
end type

type st_encounter_count from u_soap_page_base`st_encounter_count within u_soap_page_encounter_notes
end type

type pb_down from picturebutton within u_soap_page_encounter_notes
integer x = 2185
integer y = 260
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
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
alignment htextalign = left!
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_progress_display.current_page
li_last_page = dw_progress_display.last_page

dw_progress_display.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type pb_up from picturebutton within u_soap_page_encounter_notes
integer x = 2185
integer y = 132
integer width = 137
integer height = 116
integer taborder = 30
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

event clicked;integer li_page

li_page = dw_progress_display.current_page

dw_progress_display.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_soap_page_encounter_notes
boolean visible = false
integer x = 2185
integer y = 380
integer width = 151
integer height = 116
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 9/9"
boolean focusrectangle = false
end type

type dw_progress_display from u_dw_progress_display within u_soap_page_encounter_notes
integer x = 14
integer y = 144
integer width = 2117
integer height = 1108
integer taborder = 11
boolean bringtotop = true
boolean vscrollbar = true
end type

