HA$PBExportHeader$u_cpr_graph.sru
forward
global type u_cpr_graph from u_cpr_page_base
end type
type uo_graph from u_timeline_results within u_cpr_graph
end type
end forward

global type u_cpr_graph from u_cpr_page_base
uo_graph uo_graph
end type
global u_cpr_graph u_cpr_graph

forward prototypes
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
end prototypes

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

uo_graph.width = width
uo_graph.height = height

uo_graph.initialize()

end subroutine

public subroutine refresh ();uo_graph.refresh()

end subroutine

on u_cpr_graph.create
int iCurrent
call super::create
this.uo_graph=create uo_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_graph
end on

on u_cpr_graph.destroy
call super::destroy
destroy(this.uo_graph)
end on

type uo_graph from u_timeline_results within u_cpr_graph
integer width = 2386
integer height = 888
integer taborder = 10
boolean bringtotop = true
boolean border = false
end type

on uo_graph.destroy
call u_timeline_results::destroy
end on

