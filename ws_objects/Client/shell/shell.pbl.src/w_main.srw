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
end forward

global type w_main from w_window_base
integer height = 1920
boolean controlmenu = true
boolean resizable = false
event refresh ( )
event windowposchanging pbm_windowposchanging
uo_help_bar uo_help_bar
tab_main tab_main
end type
global w_main w_main

type variables
boolean doing_service
datastore id_parms
boolean initializing = true

long original_height
long original_width


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

if not doing_service &
		and isnull(current_service) &
		and not isvalid(w_logon) then
	tab_main.refresh()
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

datalist.update_preference("SYSTEM", "Computer", string(computer_id), "window_state", ls_window_state)

end subroutine

on w_main.create
int iCurrent
call super::create
this.uo_help_bar=create uo_help_bar
this.tab_main=create tab_main
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_help_bar
this.Control[iCurrent+2]=this.tab_main
end on

on w_main.destroy
call super::destroy
destroy(this.uo_help_bar)
destroy(this.tab_main)
end on

event open;call super::open;original_height = height
original_width = width

main_window = this

uo_help_bar.uf_init(this,true)

doing_service = false

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

open(w_splash)

f_cpr_set_msg("Initializing - Please Wait...")

li_sts = f_initialize_common("EncounterPRO")
if li_sts < 0 then
	if NOT IsNull(log) AND IsValid(log) then
		log.log(this, "w_main:post", "Error initializing EncounterPRO", 5)
	end if
	close(this)
	return
end if

// Enable the display of log events
log.display_enabled = true

f_cpr_set_msg("Database Connected")

li_sts = f_initialize_objects()
if li_sts < 0 then
	if NOT IsNull(log) AND IsValid(log) then
		log.log(this, "w_main:post", "Error initializing objects", 5)
	end if
	close(this)
	return
end if

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

if isvalid(w_splash) then close(w_splash)

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

end event

event timer;uo_help_bar.uf_set_clock()

refresh()

end event

event close;
if isvalid(w_image_objects) then close(w_image_objects)

If not isnull(current_user) Then
	current_user.logoff()
End If


end event

event resize;call super::resize;long ll_bottom_border

ll_bottom_border = 12

uo_help_bar.y = newheight - uo_help_bar.height
uo_help_bar.width = newwidth

service_window_width = width
service_window_height = height - uo_help_bar.height

x_factor = height / original_width
y_factor = width / original_height


pb_epro_help.x = width - 275

uo_help_bar.uf_resized()

tab_main.resize(newwidth, uo_help_bar.y)

if not initializing and isnull(current_service) then
	f_set_screen()
end if


end event

event activate;call super::activate;window lw_active_window

lw_active_window = f_active_window()

if not isnull(lw_active_window) and isvalid(lw_active_window) then
	if lw_active_window.visible then lw_active_window.show()
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_main
integer x = 2857
integer y = 0
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_main
end type

type uo_help_bar from u_help_bar within w_main
event keydown pbm_keydown
integer y = 1740
integer width = 2930
integer height = 96
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

