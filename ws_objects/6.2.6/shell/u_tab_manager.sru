HA$PBExportHeader$u_tab_manager.sru
forward
global type u_tab_manager from tab
end type
end forward

global type u_tab_manager from tab
integer width = 1152
integer height = 864
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean createondemand = true
integer selectedtab = 1
end type
global u_tab_manager u_tab_manager

type variables
u_tabpage pages[]
integer page_count

u_component_service service

end variables

forward prototypes
public subroutine resize_tabs (integer pi_width, integer pi_height)
public function integer close_pages ()
public function integer initialize ()
public function u_tabpage open_page (string ps_page_class, boolean pb_initialize)
public function u_tabpage open_page (string ps_page_class)
public function integer open_pages (string psa_page_class[], integer pi_page_count)
public subroutine refresh ()
public function integer initialize (string ps_key)
public function integer initialize (u_component_service puo_service)
end prototypes

public subroutine resize_tabs (integer pi_width, integer pi_height);integer i

resize(pi_width, pi_height)

for i = 1 to page_count
//	pages[i].resize(pi_width, pi_height)
	pages[i].EVENT TRIGGER resize_tabpage()
next


end subroutine

public function integer close_pages ();integer i

for i = page_count to 1 step -1
	if isvalid(pages[i]) and not isnull(pages[i]) then
		closetab(pages[i])
	end if
next

page_count = 0

return 1


end function

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

public function u_tabpage open_page (string ps_page_class, boolean pb_initialize);integer li_sts
u_tabpage luo_tabpage

// Open the tab
li_sts = opentab(luo_tabpage, ps_page_class, 0)
if li_sts <= 0 then
	setnull(luo_tabpage)
	return luo_tabpage
end if

// Store the tab of the pages array
page_count += 1
pages[page_count] = luo_tabpage

luo_tabpage.parent_tab = this

// If the caller wants the tab initialized, then do so
if pb_initialize then luo_tabpage.initialize()

return luo_tabpage


end function

public function u_tabpage open_page (string ps_page_class);return open_page(ps_page_class, true)



end function

public function integer open_pages (string psa_page_class[], integer pi_page_count);integer i
integer li_sts
u_tabpage luo_tabpage


for i = 1 to pi_page_count
	luo_tabpage = open_page(psa_page_class[i])
	if isnull(luo_tabpage) then return -1
next

return 1

end function

public subroutine refresh ();u_tabpage luo_page
long i

for i = 1 to page_count
		luo_page = pages[i]
	if i = selectedtab then
		luo_page.refresh()
	else
		luo_page.refresh_tabtext()
	end if
next

end subroutine

public function integer initialize (string ps_key);integer i
u_tabpage luo_tab

page_count = upperbound(control)

for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.parent_tab = this
	luo_tab.initialize(ps_key)
next

return 1

end function

public function integer initialize (u_component_service puo_service);service = puo_service
return initialize()


end function

event selectionchanged;u_tabpage luo_page

if page_count >= newindex and newindex > 0 then
	luo_page = pages[newindex]
	luo_page.refresh()
end if

end event

