$PBExportHeader$u_tab_to_be_posted_lists.sru
forward
global type u_tab_to_be_posted_lists from u_tab_manager
end type
end forward

global type u_tab_to_be_posted_lists from u_tab_manager
boolean multiline = true
event refresh_buttons ( )
event patient_posted ( string ps_posted_cpr_id,  string ps_posted_patient_name )
end type
global u_tab_to_be_posted_lists u_tab_to_be_posted_lists

type variables
u_ds_attachments attachments
str_attributes attributes

end variables

forward prototypes
public subroutine refresh ()
end prototypes

public subroutine refresh ();u_tabpage luo_page
long i
long ll_rows
string ls_null

setnull(ls_null)

attachments.setfilter("")
ll_rows = attachments.retrieve(ls_null)
if ll_rows < 0 then return

for i = 1 to page_count
		luo_page = pages[i]
	if i = selectedtab then
		luo_page.refresh()
	else
		luo_page.refresh_tabtext()
	end if
next

end subroutine

