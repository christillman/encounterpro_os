$PBExportHeader$u_component_message_stream.sru
forward
global type u_component_message_stream from u_component_base_class
end type
end forward

global type u_component_message_stream from u_component_base_class
end type
global u_component_message_stream u_component_message_stream

forward prototypes
public function integer stream_message (long pl_message_id)
protected function integer xx_stream_message (long pl_message_id)
end prototypes

public function integer stream_message (long pl_message_id);return xx_stream_message(pl_message_id)

end function

protected function integer xx_stream_message (long pl_message_id);if ole_class then
	return ole.stream_message(pl_message_id)
else
	return 100
end if


end function

on u_component_message_stream.create
TriggerEvent( this, "constructor" )
end on

on u_component_message_stream.destroy
TriggerEvent( this, "destructor" )
end on

