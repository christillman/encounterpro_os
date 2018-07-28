HA$PBExportHeader$u_tabpage.sru
forward
global type u_tabpage from userobject
end type
end forward

global type u_tabpage from userobject
integer width = 2569
integer height = 1516
long backcolor = 33538240
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event initialize ( )
event resize_tabpage ( )
event refresh ( )
event timer_ding ( )
end type
global u_tabpage u_tabpage

type variables
u_tab_manager parent_tab

u_timer_tabpage mytimer

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public function string get_build ()
public function integer initialize (string ps_key)
public subroutine refresh_tabtext ()
public subroutine start_timer (double pdbl_interval)
public subroutine stop_timer ()
end prototypes

event timer_ding();refresh()

end event

public function integer initialize ();

return 1

end function

public subroutine refresh ();
end subroutine

public function string get_build ();string ls_version
string ls_build
string ls_build_version ,ls_null

setnull(ls_null)

SELECT domain_item_description
INTO :ls_version
FROM c_Domain
WHERE domain_item = 'version';
if not tf_check() then return ls_null

SELECT domain_item_description
INTO :ls_build
FROM c_Domain
WHERE domain_item = 'build';
if not tf_check() then return ls_null

ls_build_version = trim(ls_version)+"."+trim(ls_build)

Return ls_build_version

end function

public function integer initialize (string ps_key);

return 1

end function

public subroutine refresh_tabtext ();
end subroutine

public subroutine start_timer (double pdbl_interval);

if isnull(mytimer) or not isvalid(mytimer) then
	mytimer = CREATE u_timer_tabpage
end if

mytimer.initialize_tabpage(this, pdbl_interval)


end subroutine

public subroutine stop_timer ();
if isnull(mytimer) or not isvalid(mytimer) then return

mytimer.stop()

end subroutine

on u_tabpage.create
end on

on u_tabpage.destroy
end on

