HA$PBExportHeader$u_tab_context_documents.sru
forward
global type u_tab_context_documents from u_tab_manager
end type
type tabpage_outgoing from u_tabpage_context_documents_outgoing within u_tab_context_documents
end type
type tabpage_outgoing from u_tabpage_context_documents_outgoing within u_tab_context_documents
end type
type tabpage_incoming from u_tabpage_context_documents_incoming within u_tab_context_documents
end type
type tabpage_incoming from u_tabpage_context_documents_incoming within u_tab_context_documents
end type
end forward

global type u_tab_context_documents from u_tab_manager
string tag = "OUTGOING"
integer width = 3127
integer height = 1860
boolean raggedright = false
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
tabpage_outgoing tabpage_outgoing
tabpage_incoming tabpage_incoming
end type
global u_tab_context_documents u_tab_context_documents

type variables

end variables

forward prototypes
public function integer initialize ()
end prototypes

public function integer initialize ();integer i
u_tabpage luo_tab

page_count = upperbound(control)


for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	luo_tab.initialize()
next

return 1

end function

on u_tab_context_documents.create
this.tabpage_outgoing=create tabpage_outgoing
this.tabpage_incoming=create tabpage_incoming
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_outgoing
this.Control[iCurrent+2]=this.tabpage_incoming
end on

on u_tab_context_documents.destroy
call super::destroy
destroy(this.tabpage_outgoing)
destroy(this.tabpage_incoming)
end on

type tabpage_outgoing from u_tabpage_context_documents_outgoing within u_tab_context_documents
integer x = 18
integer y = 16
integer width = 3090
integer height = 1732
string text = "Outgoing"
end type

type tabpage_incoming from u_tabpage_context_documents_incoming within u_tab_context_documents
integer x = 18
integer y = 16
integer width = 3090
integer height = 1732
string text = "Incoming"
end type

