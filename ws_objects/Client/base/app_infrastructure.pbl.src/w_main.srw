$PBExportHeader$w_main.srw
forward
global type w_main from w_window_base
end type
type uo_help_bar from u_help_bar within w_main
end type
type tab_main from u_main_tab within w_main
end type
type tab_main from u_main_tab within w_main
end type
type ole_msscript from u_msscript within w_main
end type
end forward

global type w_main from w_window_base
integer height = 1916
boolean resizable = false
event refresh ( )
event windowposchanging pbm_windowposchanging
event shutdown ( )
uo_help_bar uo_help_bar
tab_main tab_main
ole_msscript ole_msscript
end type
global w_main w_main

type variables
boolean doing_service
datastore id_parms
boolean initializing = true

long original_height
long original_width

string eml

end variables

forward prototypes
public subroutine refresh_main ()
public subroutine doing_service ()
public subroutine not_doing_service ()
public function integer refresh ()
public subroutine set_window_state (string ps_window_state)
public subroutine save_window_state ()
public subroutine save_window_state (long pl_x, long pl_y, long pl_width, long pl_height)
end prototypes

event windowposchanging;if not initializing and newwidth > 0 and newheight > 0 then
	save_window_state(xpos, ypos, newwidth, newheight)
end if


end event

event shutdown();

if IsValid(w_logon) then
	close(w_logon)
end if

close(this)

end event

public subroutine refresh_main ();
title = office_description + "  Logged On:  "
if not isnull(current_user) then
	title += current_user.user_full_name
	if lower(current_user.user_id) <> lower(current_scribe.user_id) then
		title += "  Scribed by:  " + current_scribe.user_full_name
	end if
else
	title += "<None>"
end if

end subroutine

public subroutine doing_service ();doing_service = true

end subroutine

public subroutine not_doing_service ();doing_service = false

end subroutine

public function integer refresh ();
title = office_description + "  Logged On:  "
if not isnull(current_user) then
	title += current_user.user_full_name
	if lower(current_user.user_id) <> lower(current_scribe.user_id) then
		title += "  Scribed by:  " + current_scribe.user_full_name
	end if
else
	title += "<None>"
end if

if not doing_service and isnull(current_service) then
//	if not isvalid(w_logon) then
		tab_main.refresh()
//	end if
end if

return 1

end function

public subroutine set_window_state (string ps_window_state);string lsa_state[]
integer li_count
long ll_x
long ll_y
long ll_width
long ll_height

li_count = f_parse_string(ps_window_state, ",", lsa_state)
if li_count < 5 then return

if lower(lsa_state[5]) = "maximized" then
	windowstate = maximized!
	return
end if

if not isnumber(lsa_state[1]) then return
if not isnumber(lsa_state[2]) then return
if not isnumber(lsa_state[3]) then return
if not isnumber(lsa_state[4]) then return

ll_x = long(lsa_state[1])
ll_y = long(lsa_state[2])
ll_width = long(lsa_state[3])
ll_height = long(lsa_state[4])

if ll_width <= 500 then return
if ll_height <= 500 then return

move(ll_x, ll_y)
resize(ll_width, ll_height)


end subroutine

public subroutine save_window_state ();
save_window_state(x, y, width, height)

end subroutine

public subroutine save_window_state (long pl_x, long pl_y, long pl_width, long pl_height);string ls_window_state

ls_window_state = string(pl_x)
ls_window_state += "," + string(pl_y)
ls_window_state += "," + string(pl_width)
ls_window_state += "," + string(pl_height)
ls_window_state += ","

CHOOSE CASE windowstate
	CASE normal!
		ls_window_state += "normal"
	CASE maximized!
		ls_window_state += "maximized"
	CASE ELSE
		ls_window_state += "normal"
END CHOOSE

datalist.update_preference("SYSTEM", "Computer", string(gnv_app.computer_id), "window_state", ls_window_state)

end subroutine

on w_main.create
int iCurrent
call super::create
this.uo_help_bar=create uo_help_bar
this.tab_main=create tab_main
this.ole_msscript=create ole_msscript
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_help_bar
this.Control[iCurrent+2]=this.tab_main
this.Control[iCurrent+3]=this.ole_msscript
end on

on w_main.destroy
call super::destroy
destroy(this.uo_help_bar)
destroy(this.tab_main)
destroy(this.ole_msscript)
end on

event open;call super::open;
original_height = height
original_width = width

uo_help_bar.uf_init(this,true)

doing_service = false

msscript = ole_msscript

postevent("post_open")

end event

event post_open;str_stamp lstr_stamp
integer li_sts
str_popup popup
string ls_temp
environment env
string ls_status
integer li_refresh_timer

li_sts = GetEnvironment(env)
if env.numberofcolors > 1 and env.numberofcolors < 65000 then
	f_message(17)
	log.log(this, "w_main:post", "System operating with too few colors (" + string(env.numberofcolors) + ")", 3)
end if

f_cpr_set_msg("Initializing - Please Wait...")


f_set_temp_directory("Client")

f_cpr_set_msg("")

// See if the database is OK
li_sts = f_check_system_status()
if li_sts <= 0 then
	close(this)
	return
end if

log.log(this, "w_main:post", "Done Loading.", 1)

ls_temp = datalist.get_preference("SYSTEM", "window_resizable")
if f_string_to_boolean(ls_temp) then
	resizable = true
	maxbox = true
else
	resizable = false
	maxbox = false
end if

// If the "Start Maximized" preference is true, then maximize this window
ls_temp = datalist.get_preference("SYSTEM", "window_start_maximized")
if f_string_to_boolean(ls_temp) then
	windowstate = maximized!
elseif resizable then
	// If we're not automatically starting maximized, and we are
	// resizeable, then check for a previous window state setting
	ls_temp = datalist.get_preference("SYSTEM", "window_state")
	if not isnull(ls_temp) then set_window_state(ls_temp)
else
	// If we're not automatically starting maximized, but we are
	// not resizeable, then check for a default window state setting
	ls_temp = datalist.get_preference("SYSTEM", "window_default_state")
	if not isnull(ls_temp) then set_window_state(ls_temp)
end if

ls_temp = datalist.get_preference("SYSTEM", "sync_clock")
if isnull(ls_temp) or upper(left(ls_temp, 1)) = "T" then
	ls_temp = "net time \\" + sqlca.servername + " /set /y"
	run(ls_temp, minimized!)
end if

viewed_room = current_room

tab_main.initialize()

li_refresh_timer = datalist.get_preference_int("PREFERENCES", "refresh_timer", 20)
timer(li_refresh_timer)

refresh()

tab_main.setfocus()

//get the server id

SELECT count(*)
INTO :component_manager.mod_count
FROM p_Patient;
if not tf_check() then component_manager.mod_count = 1000

lstr_stamp = f_get_stamp()

if not isnull(lstr_stamp.message) then
	openwithparm(w_pop_message, lstr_stamp.message)
end if

if not lstr_stamp.create_encounters then
	f_message(15)
end if

eml = lstr_stamp.license
component_manager.mod = eml

if lstr_stamp.license <> "D" then
	li_sts = f_check_attachment_location()
	if li_sts < 0 then
		openwithparm(w_pop_message, "An error occured while attempting to verify attachment location.  Please contact JMJ Technical Support.")
		log.log(this, "w_main:post", "Error checking attachment location", 5)
		close(this)
		return
	end if
	if li_sts = 0 then
		openwithparm(w_pop_message, "Unable to verify attachment location.  You may not be able to use attachment functionality")
	end if
end if

initializing = false

if isvalid(w_splash) then close(w_splash)


end event

event timer;uo_help_bar.uf_set_clock()

refresh()

end event

event close;

If not isnull(current_user) Then
	current_user.logoff(true)
End If


end event

event resize;call super::resize;
uo_help_bar.y = newheight - uo_help_bar.height
uo_help_bar.width = newwidth

service_window_width = width
service_window_height = height - uo_help_bar.height

x_factor = 1
y_factor = 1
IF original_width > 0 THEN
	x_factor = height / original_width
END IF
IF original_height > 0 THEN
	y_factor = width / original_height
END IF

pb_epro_help.x = width - 275

uo_help_bar.uf_resized()

tab_main.resize(newwidth, uo_help_bar.y)

if not initializing and isnull(current_service) then
	if isnull(viewed_room) then
		if isnull(current_scribe) or just_logged_on then
			tab_main.set_tab(default_group_id)
		end if
		just_logged_on = false
	else
		tab_main.set_tab_room(viewed_room)
	end if
end if


end event

event activate;call super::activate;
window lw_active_window

lw_active_window = f_active_window()

if not isnull(lw_active_window) and isvalid(lw_active_window) then
	if lw_active_window.visible then lw_active_window.show()
end if

if IsNull(current_user) AND NOT initializing then
	// When returning from Minimize, we need to re-open the logon window
	f_logon()
end if
end event

type pb_epro_help from w_window_base`pb_epro_help within w_main
boolean visible = true
integer y = 36
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_main
integer height = 64
end type

type uo_help_bar from u_help_bar within w_main
event keydown pbm_keydown
integer y = 1768
integer width = 2930
integer height = 68
end type

on uo_help_bar.destroy
call u_help_bar::destroy
end on

type tab_main from u_main_tab within w_main
boolean visible = false
integer taborder = 20
end type

event losefocus;call super::losefocus;//this.function POST setfocus()
end event

type ole_msscript from u_msscript within w_main
boolean visible = false
integer x = 155
integer y = 120
integer taborder = 20
boolean bringtotop = true
string binarykey = "w_main.win"
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
02w_main.bin 
2E00000c00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd00000004fffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000003000000000000000000000000000000000000000000000000000000005b098d1001d7efe900000003000000800000000000500003004c004200430049004e0045004500530045004b000000590000000000000000000000000000000000000000000000000000000000000000000000000002001cffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000fffffffe000000000000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000002001affffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000002400000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000101001a0000000200000001000000040e59f1d511d01fbea000f28fbc3800d1000000005b098d1001d7efe95b098d1001d7efe9000000000000000000000000fffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
2Dffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1234432100000008000003ed000003ed4e59f1d200000001000000140000271000000001000000000000000000000000000000000000000000000000000000001234432100000008000003ed000003ed4e59f1d20000000100000014000027100000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000100000024000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
12w_main.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
