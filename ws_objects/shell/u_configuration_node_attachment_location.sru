HA$PBExportHeader$u_configuration_node_attachment_location.sru
forward
global type u_configuration_node_attachment_location from u_configuration_node_base
end type
end forward

global type u_configuration_node_attachment_location from u_configuration_node_base
end type
global u_configuration_node_attachment_location u_configuration_node_attachment_location

type variables
string disabled_suffix = "  (Disabled)"

end variables

forward prototypes
public function boolean has_children ()
public function integer activate ()
public subroutine refresh_label ()
end prototypes

public function boolean has_children ();return false
end function

public function integer activate ();String		lsa_buttons[]
String 		ls_drug_id
String 		ls_description,ls_null
String		ls_top_20_code
Integer		li_sts, li_service_count
Long			ll_null
string ls_property
string ls_literal
str_property_value lstr_property_value
w_document_element_properties lw_document_element_properties
long ll_button_pressed
str_document_element_context lstr_document_element_context
window 				lw_pop_buttons
str_popup 			popup
str_popup 			popup2
str_popup_return 	popup_return
string ls_status
long ll_attachment_location_id
long ll_active_count
string ls_attachment_server
string ls_attachment_share

Setnull(ls_null)
Setnull(ll_null)


ll_attachment_location_id = long(node.key)
SELECT attachment_server, attachment_share, status
INTO :ls_attachment_server, :ls_attachment_share, :ls_status
FROM c_Attachment_Location
WHERE attachment_location_id = :ll_attachment_location_id;
if not tf_check() then return 1

if upper(ls_status) = "OK" then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Disable this attachment location"
	popup.button_titles[popup.button_count] = "Disable"
	lsa_buttons[popup.button_count] = "DISABLE"
else
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button_wrench.bmp"
	popup.button_helps[popup.button_count] = "Enable this attachment location"
	popup.button_titles[popup.button_count] = "Enable"
	lsa_buttons[popup.button_count] = "ENABLE"
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
		SELECT count(*)
		INTO :ll_active_count
		FROM c_Attachment_Location
		WHERE status = 'OK';
		if not tf_check() then return 1
		
		if ll_active_count > 1 then
			UPDATE c_Attachment_Location
			SET status = 'NA'
			WHERE attachment_location_id = :ll_attachment_location_id;
			if not tf_check() then return 1
			
			return 2
//			ltvi_item.label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share + "  (Disabled)"
//			setitem(pl_handle, ltvi_item)
		else
			openwithparm(w_pop_message, "You may not disable the only active attachment location")
			return 1
		end if
	CASE "ENABLE"
		UPDATE c_Attachment_Location
		SET status = 'OK'
		WHERE attachment_location_id = :ll_attachment_location_id;
		if not tf_check() then return 1
		
		return 2
//		ltvi_item.label = string(ll_attachment_location_id) + "    \\" + ls_attachment_server + "\" + ls_attachment_share
//		setitem(pl_handle, ltvi_item)
	CASE "CANCEL"
		return 1
	CASE ELSE
END CHOOSE

Return 1

end function

public subroutine refresh_label ();long ll_attachment_location_id
string ls_status

ll_attachment_location_id = long(node.key)

SELECT status
INTO :ls_status
FROM c_Attachment_Location
WHERE attachment_location_id = :ll_attachment_location_id;
if not tf_check() then return

if upper(ls_status) = "OK" then
	if right(node.label, len(disabled_suffix)) = disabled_suffix then
		node.label = left(node.label, len(node.label) - len(disabled_suffix))
	end if
else
	if right(node.label, len(disabled_suffix)) <> disabled_suffix then
		node.label += disabled_suffix
	end if
end if


end subroutine

on u_configuration_node_attachment_location.create
call super::create
end on

on u_configuration_node_attachment_location.destroy
call super::destroy
end on

