﻿$PBExportHeader$u_room.sru
forward
global type u_room from nonvisualobject
end type
end forward

global type u_room from nonvisualobject
end type
global u_room u_room

type variables
string room_id
string room_name
integer room_sequence
string room_type
string room_status
string status
string sort
long room_computer_id
string room_default_encounter_type
end variables

forward prototypes
public function integer set_room_status (string ps_room_status)
public function integer refresh_room_status ()
end prototypes

public function integer set_room_status (string ps_room_status);

if isnull(ps_room_status) or ps_room_status = "" then return 0

tf_begin_transaction(this, "set_room_status()")

UPDATE o_Rooms
SET room_status = :ps_room_status
WHERE room_id = :room_id;
if not tf_check() then return -1

tf_commit()

room_status = ps_room_status

return 1

end function

public function integer refresh_room_status ();SELECT room_status
INTO	:room_status
FROM o_Rooms (nolock)
WHERE room_id = :room_id;
if not tf_check() then return -1

return 1

end function

on u_room.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_room.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

