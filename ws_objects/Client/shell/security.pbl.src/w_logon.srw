$PBExportHeader$w_logon.srw
forward
global type w_logon from w_window_base
end type
type cb_exit from commandbutton within w_logon
end type
type cb_home from commandbutton within w_logon
end type
type cb_forward from commandbutton within w_logon
end type
type cb_back from commandbutton within w_logon
end type
type pb_logon from u_picture_button within w_logon
end type
type cb_cleaned from commandbutton within w_logon
end type
type cb_minimize from commandbutton within w_logon
end type
type st_copyright from statictext within w_logon
end type
type st_build_number from statictext within w_logon
end type
type ole_browser from u_browser within w_logon
end type
type p_agpl from picture within w_logon
end type
type p_logo from picture within w_logon
end type
type st_about from statictext within w_logon
end type
end forward

global type w_logon from w_window_base
integer width = 2683
integer height = 1664
boolean titlebar = false
string title = ""
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_exit cb_exit
cb_home cb_home
cb_forward cb_forward
cb_back cb_back
pb_logon pb_logon
cb_cleaned cb_cleaned
cb_minimize cb_minimize
st_copyright st_copyright
st_build_number st_build_number
ole_browser ole_browser
p_agpl p_agpl
p_logo p_logo
st_about st_about
end type
global w_logon w_logon

type variables
string access_id

string home

boolean minimizing = false

end variables

forward prototypes
public subroutine menu_old ()
public function integer get_patients_old ()
end prototypes

public subroutine menu_old ();//str_popup popup
//string buttons[]
//integer button_pressed, i, last_patient, first_patient, li_sts
//string ls_encounter_type
//
//if not isnull(current_room) then
//	first_patient = popup.button_count + 1
//	last_patient = 0
//	for i = 1 to current_room.patient_count
//		if isnull(current_room.patient[i].open_encounter) then
//			ls_encounter_type = "WELL"
//		else
//			ls_encounter_type = current_room.patient[i].open_encounter.encounter_type
//		end if
//		popup.button_count = popup.button_count + 1
//		if ls_encounter_type = "WELL" then
//			popup.button_icons[popup.button_count] = "button23.bmp"
//		else
//			popup.button_icons[popup.button_count] = "button22.bmp"
//		end if
//		popup.button_helps[popup.button_count] = current_room.patient[i].name()
//		popup.button_titles[popup.button_count] = current_room.patient[i].name_fl()
//		buttons[popup.button_count] = string(i)
//		last_patient = popup.button_count
//	next
//end if
//
//if popup.button_count > 0 then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button21.bmp"
//	popup.button_helps[popup.button_count] = "Show Patients in Office"
//	popup.button_titles[popup.button_count] = "Office"
//	buttons[popup.button_count] = "OFFICE"
//end if
//
//popup.button_titles_used = true
//
//if popup.button_count > 1 then
//	openwithparm(w_pop_buttons, popup)
//	button_pressed = message.doubleparm
//	if button_pressed < 1 or button_pressed > popup.button_count then return
//elseif popup.button_count = 1 then
//	button_pressed = 1
//else
//	if not isnull(current_room) then
//		li_sts = get_patients()
//		if li_sts <= 0 then open(w_office_main, w_logon)
//	end if
//	return
//end if
//
//if button_pressed >= first_patient and button_pressed <= last_patient then
//	i = integer(buttons[button_pressed])
//	current_room.patient[i].do_workflow()
//else
//	CHOOSE CASE buttons[button_pressed]
//		CASE "OFFICE"
//			open(w_office_main, w_logon)
//		CASE ELSE
//	END CHOOSE
//end if
//
//return
end subroutine

public function integer get_patients_old ();//str_popup popup
//str_popup_return popup_return
//integer i, li_ready_count, li_index, li_sts
//integer lia_patient_index[]
//u_patient luo_patient
//datetime ldt_null
//
//setnull(ldt_null)
//
//if not current_user.can_do_service("GET_PATIENT") then return 0
//
//li_ready_count = 0
//for i = 1 to patient_list.patient_count
//	if isnull(patient_list.patient[i].open_encounter) then continue
//	li_index = patient_list.patient[i].open_encounter.find_service("GET_PATIENT")
//	if li_index = 0 then continue
//	li_ready_count += 1
//	lia_patient_index[li_ready_count] = i
//	popup.items[li_ready_count] = patient_list.patient[i].name()
//next
//
//if li_ready_count = 0 then return 0
//
//popup.multiselect = true
//popup.data_row_count = li_ready_count
//openwithparm(w_pop_pick, popup)
//popup_return = message.powerobjectparm
//
//if popup_return.item_count = 0 then return 0
//
//followon_service = true
//
//for i = 1 to popup_return.item_count
//	luo_patient = patient_list.patient[lia_patient_index[popup_return.item_indexes[i]]]
//	luo_patient.current_encounter_log_index = luo_patient.open_encounter.find_service("GET_PATIENT")
//	if luo_patient.current_encounter_log_index = 0 then continue
//	current_patient = luo_patient
//	li_sts = current_patient.lock_patient()
//	if li_sts <= 0 then
//		log.log(this, "w_logon.get_patients_old:0040", "Unable to lock patient", 4)
//		setnull(current_patient)
//		continue
//	end if
//	luo_patient.do_service()
//next
//
//followon_service = false
//current_user.logoff()
//
return 1
end function

event open;call super::open;integer i, li_row
string ls_temp
integer li_sts
long ll_x
integer li_refresh_timer
environment env
integer rtn
rtn = GetEnvironment(env)

bringtotop = true
If IsValid(main_window) Then
	// When main window is open, hide it.
	main_window.Hide()
	//windowstate = maximized!
End If

// Could this ever happen?
if not isnull(current_user) and isvalid(current_user) then current_user.logoff(false)

setnull(viewed_room)

If IsValid(main_window) Then
	main_window.title = "EncounterPRO Logon"
End If

st_build_number.text = f_app_version()

li_refresh_timer = datalist.get_preference_int("PREFERENCES", "refresh_timer", 20)
timer(li_refresh_timer, this)

// Move stuff around

x = (env.ScreenWidth - width) / 2
y = (env.ScreenHeight - height) / 2

cb_exit.x = width - cb_exit.width - 20

cb_cleaned.x = (width - cb_cleaned.width) / 2
pb_logon.x = width - 384

st_copyright.text = gnv_app.copyright

ls_temp = datalist.get_preference("PREFERENCES", "logon_show_minimize_button")
if not isnull(ls_temp) then
	cb_minimize.visible = f_string_to_boolean(ls_temp)
end if

ls_temp = datalist.get_preference("PREFERENCES", "logon_show_exit_button")
if not isnull(ls_temp) then
	cb_exit.visible = f_string_to_boolean(ls_temp)
end if

ls_temp = datalist.get_preference("PREFERENCES", "logon_button")
if not isnull(ls_temp) then pb_logon.picturename = ls_temp

ls_temp = datalist.get_preference("PREFERENCES", "logon_browser_url")
if isnull(ls_temp) or trim(ls_temp) = "" then
	ole_browser.visible = false
	cb_back.visible = false
	cb_forward.visible = false
	cb_home.visible = false
	setnull(home)
else
	home = ls_temp
	ole_browser.x = 0
	ole_browser.y = cb_home.y + cb_home.height + 30
	ole_browser.width = width
	ole_browser.height = height - ole_browser.y
	ole_browser.visible = true
	ole_browser.object.navigate(home)
	ls_temp = datalist.get_preference("PREFERENCES", "logon_browser_navigate")
	if isnull(ls_temp) or upper(left(ls_temp, 1)) <> "T" then
		cb_back.visible = false
		cb_forward.visible = false
		cb_home.visible = false
	else
		cb_back.visible = true
		cb_forward.visible = true
		cb_home.visible = true
	end if
end if


postevent("timer")

end event

event timer;integer li_sts

if not isnull(current_room) AND IsValid(current_room) then
	current_room.refresh_room_status()
	if current_room.room_status = "DIRTY" then
		cb_cleaned.visible = true
	else
		cb_cleaned.visible = false
	end if
end if

IF not IsNull(main_window) AND IsValid(main_window) THEN
	IF not isnull(main_window.uo_help_bar) AND IsValid(main_window.uo_help_bar) THEN
		main_window.uo_help_bar.uf_set_clock()
	end if
END IF

// See if the database is OK
li_sts = f_check_system_status()
if li_sts <= 0 then
	MessageBox("Closing down", "w_logon was disconnected")
	DebugBreak()
	gnv_app.event close()
end if


end event

on w_logon.create
int iCurrent
call super::create
this.cb_exit=create cb_exit
this.cb_home=create cb_home
this.cb_forward=create cb_forward
this.cb_back=create cb_back
this.pb_logon=create pb_logon
this.cb_cleaned=create cb_cleaned
this.cb_minimize=create cb_minimize
this.st_copyright=create st_copyright
this.st_build_number=create st_build_number
this.ole_browser=create ole_browser
this.p_agpl=create p_agpl
this.p_logo=create p_logo
this.st_about=create st_about
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exit
this.Control[iCurrent+2]=this.cb_home
this.Control[iCurrent+3]=this.cb_forward
this.Control[iCurrent+4]=this.cb_back
this.Control[iCurrent+5]=this.pb_logon
this.Control[iCurrent+6]=this.cb_cleaned
this.Control[iCurrent+7]=this.cb_minimize
this.Control[iCurrent+8]=this.st_copyright
this.Control[iCurrent+9]=this.st_build_number
this.Control[iCurrent+10]=this.ole_browser
this.Control[iCurrent+11]=this.p_agpl
this.Control[iCurrent+12]=this.p_logo
this.Control[iCurrent+13]=this.st_about
end on

on w_logon.destroy
call super::destroy
destroy(this.cb_exit)
destroy(this.cb_home)
destroy(this.cb_forward)
destroy(this.cb_back)
destroy(this.pb_logon)
destroy(this.cb_cleaned)
destroy(this.cb_minimize)
destroy(this.st_copyright)
destroy(this.st_build_number)
destroy(this.ole_browser)
destroy(this.p_agpl)
destroy(this.p_logo)
destroy(this.st_about)
end on

event key;// Override so the key events don't get processed

end event

type pb_epro_help from w_window_base`pb_epro_help within w_logon
integer x = 2857
integer y = 132
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_logon
end type

type cb_exit from commandbutton within w_logon
integer x = 2569
integer y = 4
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "X"
end type

event clicked;
if isnull(current_user) and not minimizing then
	IF IsValid(main_window) THEN
		main_window.postevent("shutdown")
	END IF
end if

CloseWithReturn(parent, -1)
end event

type cb_home from commandbutton within w_logon
integer x = 530
integer y = 1264
integer width = 219
integer height = 132
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Home"
end type

event clicked;ole_browser.object.navigate(home)

end event

type cb_forward from commandbutton within w_logon
integer x = 293
integer y = 1264
integer width = 219
integer height = 132
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Fwd"
end type

event clicked;ole_browser.object.goforward()

end event

type cb_back from commandbutton within w_logon
integer x = 55
integer y = 1264
integer width = 219
integer height = 132
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Back"
end type

event clicked;ole_browser.object.goback()

end event

type pb_logon from u_picture_button within w_logon
integer x = 2341
integer y = 64
integer taborder = 30
boolean default = true
boolean originalsize = false
string picturename = "BUTTON10.bmp"
string disabledname = "b_push10.bmp"
vtextalign vtextalign = top!
end type

event clicked;call super::clicked;str_popup popup
integer li_sts

f_user_logon()
if isnull(current_user) then return

current_user.sticky_logon = true
just_logged_on = true

viewed_room = current_room
f_set_screen()

If IsValid(main_window) Then
	// When main window is open, show it.
	// For the first logon, it is not yet open.
	main_window.Show()
End If

CloseWithReturn(parent, 1)

end event

type cb_cleaned from commandbutton within w_logon
boolean visible = false
integer x = 805
integer y = 24
integer width = 1266
integer height = 216
integer textsize = -20
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cleaned"
end type

on clicked;if not isnull(current_room) then
	current_room.set_room_status("OK")
	visible = false
end if

end on

type cb_minimize from commandbutton within w_logon
boolean visible = false
integer width = 320
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Minimize"
end type

event clicked;
// This seems to make the window disappear without leaving a trace 
// in the task bar under Windows 10. 
// Making the button invisible.
If IsValid(main_window) Then
	main_window.windowstate = Minimized!
	parent.windowstate = Minimized!
	minimizing = true
End If

//CloseWithReturn(parent, 0)
end event

type st_copyright from statictext within w_logon
integer x = 46
integer y = 216
integer width = 1262
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "{gnv_app.copyright}"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_build_number from statictext within w_logon
integer x = 46
integer y = 148
integer width = 1262
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Build 159"
alignment alignment = center!
boolean focusrectangle = false
end type

type ole_browser from u_browser within w_logon
boolean visible = false
integer y = 272
integer width = 2912
integer height = 1548
integer taborder = 40
boolean border = false
borderstyle borderstyle = stylebox!
string binarykey = "w_logon.win"
end type

event commandstatechange;call super::commandstatechange;
//if enable then
//	messagebox("Football", string(command) + "  true")
//else
//	messagebox("Football", string(command) + "  false")
//end if
CHOOSE CASE command
	CASE 1
		cb_forward.enabled = enable
	CASE 2
		cb_back.enabled = enable
END CHOOSE

end event

type p_agpl from picture within w_logon
integer x = 59
integer y = 1416
integer width = 709
integer height = 204
boolean bringtotop = true
boolean originalsize = true
string picturename = "agplv3-155x51.png"
boolean focusrectangle = false
end type

type p_logo from picture within w_logon
integer y = 4
integer width = 2674
integer height = 1652
string picturename = "greenolivehr-background.png"
boolean focusrectangle = false
end type

type st_about from statictext within w_logon
integer x = 46
integer y = 284
integer width = 1262
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = " Click ~"About EncounterPRO-OS~" for More Information."
alignment alignment = center!
boolean focusrectangle = false
end type

event clicked;
open(w_about_encounterpro) 
end event


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cw_logon.bin 
2200000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000005ce73d2001d9c5ae00000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000005ce73d2001d9c5ae5ce73d2001d9c5ae000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
22ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c000041d6000027ff0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c000041d6000027ff0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cw_logon.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
