HA$PBExportHeader$u_param_noop.sru
forward
global type u_param_noop from u_param_base
end type
end forward

global type u_param_noop from u_param_base
end type
global u_param_noop u_param_noop

forward prototypes
public function integer pick_param ()
end prototypes

public function integer pick_param ();return 1

end function

on u_param_noop.create
call super::create
end on

on u_param_noop.destroy
call super::destroy
end on

type cb_clear from u_param_base`cb_clear within u_param_noop
end type

type st_required from u_param_base`st_required within u_param_noop
boolean visible = false
end type

type st_helptext from u_param_base`st_helptext within u_param_noop
end type

type st_title from u_param_base`st_title within u_param_noop
boolean visible = false
end type

