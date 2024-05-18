$PBExportHeader$u_cpr_section.sru
forward
global type u_cpr_section from nonvisualobject
end type
end forward

global type u_cpr_section from nonvisualobject
end type
global u_cpr_section u_cpr_section

type variables
long chart_id
long section_id
string description
string bitmap
string tab_location

u_cpr_page_base section_object

integer page_count
str_cpr_page page[]

boolean default

long page_x
long page_y

u_ds_data attributes

w_cpr_main my_cpr_main

end variables

forward prototypes
public function integer open_pages ()
public function integer load_params (integer pi_page)
public function string get_attribute (long pl_page_id, string ps_attribute_tag, string ps_attribute)
public function string get_attribute (long pl_page_id, string ps_attribute)
public subroutine section_selected ()
public subroutine page_selected (integer pi_page)
public subroutine refresh_other_tabs (integer pi_page)
end prototypes

public function integer open_pages ();
return 1

end function

public function integer load_params (integer pi_page);integer li_count

attributes.set_dataobject("dw_c_chart_section_page_attribute")
li_count = attributes.retrieve(chart_id, section_id)

return li_count


end function

public function string get_attribute (long pl_page_id, string ps_attribute_tag, string ps_attribute);long ll_row
string ls_find
string ls_value
long ll_count
string ls_find_user
long ll_null

setnull(ll_null)

setnull(ls_value)
ll_count = attributes.rowcount()

ls_find = "page_id=" + string(pl_page_id)
if not isnull(ps_attribute_tag) then ls_find += " and lower(attribute_tag)='" + lower(ps_attribute_tag) + "'"
ls_find += " and lower(attribute)='" + lower(ps_attribute) + "'"

// First, see if the attribute exists for the user
ls_find_user = ls_find + " and user_id='" + current_user.user_id + "'"
ll_row = attributes.find(ls_find_user, 1, ll_count)
if ll_row > 0 then ls_value = attributes.object.value[ll_row]

if isnull(ls_value) then
	// Then, see if the attribute exists for the specialty
	ls_find_user = ls_find + " and user_id='" + current_user.specialty_id + "'"
	ll_row = attributes.find(ls_find_user, 1, ll_count)
	if ll_row > 0 then ls_value = attributes.object.value[ll_row]
end if

if isnull(ls_value) then
	// Then, see if it exists without user qualification
	ll_row = attributes.find(ls_find, 1, ll_count)
	if ll_row > 0 then ls_value = attributes.object.value[ll_row]
end if

if isnull(ls_value) then
	// Finally, see if there's a default parameter for this page
	for ll_row = 1 to page_count
		if page[ll_row].page_id = pl_page_id then
			ls_value = datalist.get_chart_page_attribute(page[ll_row].page_class, ps_attribute)
			exit
		end if
	next
end if

return f_attribute_value_substitute(current_patient.cpr_id, ll_null, ls_value)




end function

public function string get_attribute (long pl_page_id, string ps_attribute);string ls_attribute_tag

setnull(ls_attribute_tag)

return get_attribute(pl_page_id, ls_attribute_tag, ps_attribute)

end function

public subroutine section_selected ();string ls_text

if section_object.refresh_on_display or not section_object.displayed then
	TRY
		section_object.refresh()
	CATCH (throwable lt_error)
		ls_text = "Error refreshing a chart section ("
		ls_text += string(chart_id) + ", " + string(section_id) + ").  The following error message was returned:  "
		ls_text += lt_error.text
		log.log(this, "u_cpr_section.section_selected:0010", ls_text, 4)
		return
	END TRY
	section_object.displayed = true
end if


end subroutine

public subroutine page_selected (integer pi_page);if page[pi_page].page_object.refresh_on_display or not page[pi_page].page_object.displayed then
	page[pi_page].page_object.refresh()
	page[pi_page].page_object.displayed = true
end if


end subroutine

public subroutine refresh_other_tabs (integer pi_page);integer i

// refresh the displayed page and refresh the tab of all the undisplayed pages
for i = 1 to page_count
	if i <> pi_page then page[i].page_object.refresh_tab()
next

end subroutine

on u_cpr_section.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_cpr_section.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;attributes = CREATE u_ds_data

end event

event destructor;DESTROY attributes

end event

