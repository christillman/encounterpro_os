$PBExportHeader$u_tabpage_documents.sru
forward
global type u_tabpage_documents from u_tabpage
end type
type tab_documents from u_tab_context_documents within u_tabpage_documents
end type
type tab_documents from u_tab_context_documents within u_tabpage_documents
end type
end forward

global type u_tabpage_documents from u_tabpage
integer width = 3291
integer height = 2024
tab_documents tab_documents
end type
global u_tabpage_documents u_tabpage_documents

type variables
boolean first_time = true

string view_context_object
string view_cpr_id
long view_object_key
date begin_date
date end_date

string tab_text = "Documents"


end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
public subroutine refresh_tabtext ()
end prototypes

public function integer initialize ();integer li_sts

setnull(begin_date)
setnull(end_date)

if isnull(parent_tab.service) or not isvalid(parent_tab.service) then
	if isnull(current_service) or not isvalid(current_service) then
		log.log(this, "initialize()", "Service context not found", 4)
	else
		view_context_object = current_service.context_object
		view_cpr_id = current_service.cpr_id
		view_object_key = current_service.object_key
	end if
else
	view_context_object = parent_tab.service.context_object
	view_cpr_id = parent_tab.service.cpr_id
	view_object_key = parent_tab.service.object_key
end if

// We need this because some older screens have create-on-demand turned on so the tabpage misses the first refresh pass
refresh_tabtext()

return 1


end function

public subroutine refresh ();if first_time then
	tab_documents.initialize()
	tab_documents.resize_tabs(width, height)
	first_time = false
end if

tab_documents.refresh()

refresh_tabtext()

end subroutine

public subroutine refresh_tabtext ();long ll_ready_count
long ll_total_count
long ll_cancelled_count
string ls_new_tab_text
long ll_new_tab_color
long ll_incoming_count

SELECT ready_count, total_count, cancelled_count, incoming_count
INTO :ll_ready_count, :ll_total_count, :ll_cancelled_count, :ll_incoming_count
FROM dbo.fn_count_documents_for_object(:view_context_object, :view_cpr_id, :view_object_key, :begin_date, :end_date);
if not tf_check() then return


ls_new_tab_text = tab_text + " ("

ls_new_tab_text += string(ll_ready_count)
ls_new_tab_text +=  + "/" + string(ll_total_count) 
ls_new_tab_text +=  + "/" + string(ll_incoming_count) 
ls_new_tab_text +=  + ")"



if ll_ready_count > 0 then
	ll_new_tab_color = color_text_error
else
	ll_new_tab_color = color_text_normal
end if

// updating the visible property is expensive on terminal servers so only do it if it has changed
if text <> ls_new_tab_text then text = ls_new_tab_text
if tabtextcolor <> ll_new_tab_color then tabtextcolor = ll_new_tab_color


return

end subroutine

on u_tabpage_documents.create
int iCurrent
call super::create
this.tab_documents=create tab_documents
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_documents
end on

on u_tabpage_documents.destroy
call super::destroy
destroy(this.tab_documents)
end on

event resize_tabpage;call super::resize_tabpage;tab_documents.resize(width, height)

end event

type tab_documents from u_tab_context_documents within u_tabpage_documents
string tag = ""
integer taborder = 20
end type

