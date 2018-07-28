HA$PBExportHeader$u_component_timer.sru
forward
global type u_component_timer from timing
end type
end forward

global type u_component_timer from timing
end type
global u_component_timer u_component_timer

type variables
nonvisualobject component
end variables

forward prototypes
public subroutine shutdown ()
public subroutine start_timer ()
public subroutine start_timer (double pdb_interval)
public subroutine stop_timer ()
public subroutine initialize (nonvisualobject puo_component, double pdb_interval)
end prototypes

public subroutine shutdown ();stop()

end subroutine

public subroutine start_timer ();if interval <= 0 then return

start_timer(interval)

end subroutine

public subroutine start_timer (double pdb_interval);start(pdb_interval)

end subroutine

public subroutine stop_timer ();stop()

end subroutine

public subroutine initialize (nonvisualobject puo_component, double pdb_interval);component = puo_component

if pdb_interval > 0 then start(pdb_interval)


end subroutine

on u_component_timer.create
call timing::create
TriggerEvent( this, "constructor" )
end on

on u_component_timer.destroy
call timing::destroy
TriggerEvent( this, "destructor" )
end on

event timer;component.postevent("timer")
end event

