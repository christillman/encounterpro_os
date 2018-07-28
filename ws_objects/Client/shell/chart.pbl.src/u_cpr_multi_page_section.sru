$PBExportHeader$u_cpr_multi_page_section.sru
forward
global type u_cpr_multi_page_section from u_cpr_page_base
end type
type tab_pages from u_cpr_multi_page_tab within u_cpr_multi_page_section
end type
type tab_pages from u_cpr_multi_page_tab within u_cpr_multi_page_section
end type
end forward

global type u_cpr_multi_page_section from u_cpr_page_base
string tag = "tab_pages"
tab_pages tab_pages
end type
global u_cpr_multi_page_section u_cpr_multi_page_section

type variables
boolean pages_open = false

end variables

forward prototypes
public function integer open_pages ()
public subroutine initialize (u_cpr_section puo_section, integer pi_page)
public subroutine refresh ()
public function integer close_pages ()
public subroutine finished ()
public subroutine post_refresh ()
public subroutine key_down (keycode key, unsignedlong keyflags)
public function integer setfocus ()
end prototypes

public function integer open_pages ();integer i
string ls_text


for i = 1 to this_section.page_count
	TRY
		tab_pages.opentab(this_section.page[i].page_object, this_section.page[i].page_class, 0)
	CATCH (throwable lt_error)
		ls_text = "EncounterPRO encountered an error opening a chart page ("
		ls_text += this_section.page[i].page_class + ").  The following error message was returned:  "
		ls_text += lt_error.text
		log.log(this, "open_pages()", ls_text, 4)
		chart_window.event POST load_error("EncounterPRO encountered an error opening the chart")
		return -1
	END TRY
	
	this_section.page[i].page_object.tabbackcolor = color_object
	this_section.page[i].page_object.text = this_section.page[i].description
	this_section.page[i].page_object.picturename = this_section.page[i].bitmap
	this_section.page[i].page_object.wait_window = wait_window
	this_section.page[i].page_object.chart_window = chart_window
	
	if isvalid(wait_window) then wait_window.bump_progress()
next

for i = 1 to this_section.page_count
	TRY
		this_section.page[i].page_object.initialize(this_section, i)
	CATCH (throwable lt_error2)
		ls_text = "EncounterPRO encountered an error initializing a chart page ("
		ls_text += this_section.page[i].page_class + ").  The following error message was returned:  "
		ls_text += lt_error2.text
		log.log(this, "open_pages()", ls_text, 4)
		chart_window.event POST load_error("EncounterPRO encountered an error initializing the chart")
		return -1
	END TRY
	
	if isvalid(wait_window) then wait_window.bump_progress()
next

pages_open = true

return 1

end function

public subroutine initialize (u_cpr_section puo_section, integer pi_page);this_section = puo_section
this_page = pi_page

tab_pages.mysection = this

tab_pages.width = width
tab_pages.height = height

this_section.page_x += 10
this_section.page_y += 10

CHOOSE CASE upper(left(this_section.tab_location, 1))
	CASE "T"
		tab_pages.tabposition = TabsOnTop!
		tab_pages.raggedright = false
		tab_pages.perpendiculartext = false
	CASE "B"
		tab_pages.tabposition = TabsOnBottom!
		tab_pages.raggedright = false
		tab_pages.perpendiculartext = false
	CASE "L"
		tab_pages.tabposition = TabsOnLeft!
		tab_pages.raggedright = true
		tab_pages.perpendiculartext = true
	CASE ELSE
		// Default is right side
		tab_pages.tabposition = TabsOnRight!
		tab_pages.raggedright = true
		tab_pages.perpendiculartext = true
END CHOOSE


end subroutine

public subroutine refresh ();integer i
integer li_sts

if pages_open then
	// refresh the displayed page and refresh the tab of all the undisplayed pages
	for i = 1 to this_section.page_count
		if i = tab_pages.selectedtab then
			this_section.page[i].page_object.refresh()
		else
			this_section.page[i].page_object.refresh_tab()
		end if
	next
else
	li_sts = open_pages()
	//msc commented out because first tab will automatically be selected and
	// selectionchanging event has already been posted
//	tab_pages.selecttab(1)
end if


end subroutine

public function integer close_pages ();integer i
integer li_sts

for i = 1 to this_section.page_count
	if isvalid(this_section.page[i].page_object) then
		this_section.page[i].page_object.finished()
		li_sts = tab_pages.closetab(this_section.page[i].page_object)
	end if
next

pages_open = false

return 1

end function

public subroutine finished ();integer li_sts


li_sts = close_pages()

end subroutine

public subroutine post_refresh ();postevent("refresh")

end subroutine

public subroutine key_down (keycode key, unsignedlong keyflags);

// pass the keystroke into the tab
if tab_pages.selectedtab > 0 then
	this_section.page[tab_pages.selectedtab].page_object.key_down(key, keyflags)
end if

end subroutine

public function integer setfocus ();return tab_pages.setfocus()

end function

on u_cpr_multi_page_section.create
int iCurrent
call super::create
this.tab_pages=create tab_pages
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_pages
end on

on u_cpr_multi_page_section.destroy
call super::destroy
destroy(this.tab_pages)
end on

type cb_configure_tab from u_cpr_page_base`cb_configure_tab within u_cpr_multi_page_section
end type

type tab_pages from u_cpr_multi_page_tab within u_cpr_multi_page_section
integer taborder = 11
end type

event selectionchanging;call super::selectionchanging;if isnull(this_section) or not isvalid(this_section) then return
if not pages_open then return

if oldindex > 0 then this_section.page[oldindex].page_object.tabbackcolor = color_object
this_section.page[newindex].page_object.tabbackcolor = color_object_selected

this_section.page_selected(newindex)

end event

event refresh;call super::refresh;post_refresh()


end event

