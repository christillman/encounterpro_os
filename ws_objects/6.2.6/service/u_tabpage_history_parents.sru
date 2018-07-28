HA$PBExportHeader$u_tabpage_history_parents.sru
forward
global type u_tabpage_history_parents from u_tabpage
end type
end forward

global type u_tabpage_history_parents from u_tabpage
end type
global u_tabpage_history_parents u_tabpage_history_parents

type variables
u_component_service service
u_tab_history_parents tab_parents


end variables

forward prototypes
public subroutine history_clicked ()
public subroutine refresh_display (long pl_key)
end prototypes

public subroutine history_clicked ();
end subroutine

public subroutine refresh_display (long pl_key);
end subroutine

on u_tabpage_history_parents.create
call super::create
end on

on u_tabpage_history_parents.destroy
call super::destroy
end on

