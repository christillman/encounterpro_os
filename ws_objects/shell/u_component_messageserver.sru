HA$PBExportHeader$u_component_messageserver.sru
forward
global type u_component_messageserver from u_component_base_class
end type
end forward

global type u_component_messageserver from u_component_base_class
end type
global u_component_messageserver u_component_messageserver

type variables
u_component_incoming subscriptions[]
integer subscription_count
string log_compression_type
string cpr_id
long encounter_id
string batch_mode
end variables

forward prototypes
protected function integer xx_send_to_subscribers (string ps_message_type, string ps_filename)
public function integer send_to_subscribers (string ps_message_type, string ps_filename)
protected function integer base_initialize ()
public function integer send_to_subscribers (string ps_message_type, string ps_filename, string ps_cpr_id, long pl_encounter_id)
public function integer send_to_subscribers (string ps_message_type, string ps_filename, string ps_cpr_id, long pl_encounter_id, string ps_batch)
end prototypes

protected function integer xx_send_to_subscribers (string ps_message_type, string ps_filename);if ole_class then
	return ole.send_to_subscribers(ps_message_type, ps_filename)
else
	return 100
end if


end function

public function integer send_to_subscribers (string ps_message_type, string ps_filename);return xx_send_to_subscribers(ps_message_type, ps_filename)


end function

protected function integer base_initialize ();log_compression_type = "NONE"

return 1

end function

public function integer send_to_subscribers (string ps_message_type, string ps_filename, string ps_cpr_id, long pl_encounter_id);cpr_id = ps_cpr_id
encounter_id = pl_encounter_id

return xx_send_to_subscribers(ps_message_type,ps_filename)
end function

public function integer send_to_subscribers (string ps_message_type, string ps_filename, string ps_cpr_id, long pl_encounter_id, string ps_batch);cpr_id = ps_cpr_id
encounter_id = pl_encounter_id
batch_mode = ps_batch

return xx_send_to_subscribers(ps_message_type,ps_filename)
end function

on u_component_messageserver.create
call super::create
end on

on u_component_messageserver.destroy
call super::destroy
end on

