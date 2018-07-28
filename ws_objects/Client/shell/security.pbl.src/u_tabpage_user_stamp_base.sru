$PBExportHeader$u_tabpage_user_stamp_base.sru
forward
global type u_tabpage_user_stamp_base from u_tabpage
end type
end forward

global type u_tabpage_user_stamp_base from u_tabpage
end type
global u_tabpage_user_stamp_base u_tabpage_user_stamp_base

forward prototypes
public function integer save ()
public function boolean stamp_changed ()
public function integer initialize (u_user puo_user)
end prototypes

public function integer save ();return 0

end function

public function boolean stamp_changed ();return false

end function

public function integer initialize (u_user puo_user);

return 1

end function

on u_tabpage_user_stamp_base.create
call super::create
end on

on u_tabpage_user_stamp_base.destroy
call super::destroy
end on

