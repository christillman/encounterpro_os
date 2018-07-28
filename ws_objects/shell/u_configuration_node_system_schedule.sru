HA$PBExportHeader$u_configuration_node_system_schedule.sru
forward
global type u_configuration_node_system_schedule from u_configuration_node_base
end type
end forward

global type u_configuration_node_system_schedule from u_configuration_node_base
end type
global u_configuration_node_system_schedule u_configuration_node_system_schedule

forward prototypes
public function boolean has_children ()
public function integer activate ()
end prototypes

public function boolean has_children ();return false

end function

public function integer activate ();String		lsa_buttons[]
String 		ls_null
Integer		li_sts, li_service_count
Long			ll_null
long ll_button_pressed
window 				lw_pop_buttons
str_popup 			popup
str_popup_return 	popup_return
string ls_status
long i
long ll_service_sequence
w_window_base lw_window

Setnull(ls_null)
Setnull(ll_null)

ll_service_sequence = long(node.key)

SELECT status
INTO :ls_status
FROM dbo.fn_scheduled_services()
WHERE service_sequence = :ll_service_sequence;
if not tf_check() then return -1

if upper(ls_status) = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Disable Scheduled Task"
	popup.button_titles[popup.button_count] = "Disable"
	lsa_buttons[popup.button_count] = "DISABLE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Enable Scheduled Task"
	popup.button_titles[popup.button_count] = "Enable"
	lsa_buttons[popup.button_count] = "ENABLE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Edit Scheduled Task"
	popup.button_titles[popup.button_count] = "Edit"
	lsa_buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Scheduled Task"
	popup.button_titles[popup.button_count] = "Delete"
	lsa_buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	lsa_buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	ll_button_pressed = message.doubleparm
	if ll_button_pressed < 1 or ll_button_pressed > popup.button_count then return 1
elseif popup.button_count = 1 then
	ll_button_pressed = 1
else
	return 1
end if

CHOOSE CASE lsa_buttons[ll_button_pressed]
	CASE "DISABLE"
		openwithparm(w_pop_yes_no, "Are you sure you want to disable this scheduled task?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
		
		UPDATE o_Service_Schedule
		SET status = 'NA'
		WHERE service_sequence = :ll_service_sequence;
		if not tf_check() then return 1
		return 3
	CASE "ENABLE"
		openwithparm(w_pop_yes_no, "Are you sure you want to enable this scheduled task?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1

		UPDATE o_Service_Schedule
		SET status = 'OK'
		WHERE service_sequence = :ll_service_sequence;
		if not tf_check() then return 1
		return 3
	CASE "EDIT"
		openwithparm(lw_window, ll_service_sequence, "w_scheduled_service_edit")
		return 3
	CASE "DELETE"
		openwithparm(w_pop_yes_no, "Are you sure you want to delete this scheduled task?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return 1
		
		tf_begin_transaction(this, "Delete Schedule")
		DELETE FROM o_Service_Schedule_attribute
		WHERE service_sequence = :ll_service_sequence;
		if not tf_check() then return 1
		
		DELETE FROM o_Service_Schedule
		WHERE service_sequence = :ll_service_sequence;
		if not tf_check() then return 1
		tf_commit_transaction()
		
		return 3
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1


end function

on u_configuration_node_system_schedule.create
call super::create
end on

on u_configuration_node_system_schedule.destroy
call super::destroy
end on

