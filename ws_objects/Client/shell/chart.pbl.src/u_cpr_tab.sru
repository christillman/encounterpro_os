$PBExportHeader$u_cpr_tab.sru
forward
global type u_cpr_tab from tab
end type
end forward

global type u_cpr_tab from tab
integer width = 2903
integer height = 1408
integer taborder = 1
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 1
event wmpaint pbm_paint
event postpaint ( )
event refresh ( )
end type
global u_cpr_tab u_cpr_tab

type variables
u_cpr_section section[]
integer section_count

boolean initializing = true

boolean selectionchanging = false

long minheight = 500

long chart_id

w_pop_please_wait wait_window
w_cpr_main chart_window

end variables

forward prototypes
public subroutine refresh ()
public function integer windowposchanging (long pl_x, long pl_y, long pl_width, long pl_height, long pl_flags)
public subroutine finished ()
public subroutine select_default_tab ()
public function integer initialize ()
public function long get_chart_id ()
public subroutine closetab ()
public function integer get_section_list ()
public function integer open_section_pages ()
end prototypes

event wmpaint;postevent("postpaint")

end event

event postpaint;if selectedtab > 0 and section_count >= selectedtab and not selectionchanging then
	section[selectedtab].section_object.postevent("repaint")
end if

selectionchanging = false

end event

public subroutine refresh ();if selectedtab > 0 and section_count >= selectedtab then section[selectedtab].section_object.refresh()

end subroutine

public function integer windowposchanging (long pl_x, long pl_y, long pl_width, long pl_height, long pl_flags);integer li_sts

log.log(this, "u_cpr_tab.windowposchanging:0003", string(pl_x) + ", " + string(pl_y) + ", " + string(pl_width) + ", " + string(pl_height) + ", " + string(pl_flags), 2)

li_sts = 1

if selectedtab <= 0 then li_sts = 0

if section_count < selectedtab then li_sts = 0

if not isvalid(w_main) then li_sts = 0

if li_sts > 0 then
	if pl_height < minheight then
		section[selectedtab].section_object.minimize()
	else
		if w_main.windowstate = Minimized! then
			section[selectedtab].section_object.postevent("refresh")
		else
			li_sts = section[selectedtab].section_object.size_and_position_window()
		end if
	end if
end if

return li_sts

end function

public subroutine finished ();integer i

for i = 1 to section_count
	if isvalid(section[i].section_object) then
		section[i].section_object.finished()
		closetab(section[i].section_object)
		DESTROY section[i]
		setnull(section[i])
	end if
next

section_count = 0



end subroutine

public subroutine select_default_tab ();integer i

if section_count <= 0 then return

for i = 1 to section_count
	if section[i].default then
		selecttab(i)
		return
	end if
next

selecttab(1)

end subroutine

public function integer initialize ();integer li_sts

log.log(this, "u_cpr_tab.initialize:0003", "calling get_section_list()", 1)
li_sts = get_section_list()
if li_sts <= 0 then return li_sts

log.log(this, "u_cpr_tab.initialize:0007", "calling open_section_pages()", 1)
li_sts = open_section_pages()
if li_sts <= 0 then return li_sts

return 1


end function

public function long get_chart_id ();long ll_chart_id
u_ds_data luo_data
string ls_current_workplan_guid
long ll_patient_workplan_id
string ls_user_id
string ls_specialty_id
long ll_rowcount
long i
string ls_workplan_guid

setnull(ls_current_workplan_guid)
// See if we should use the encounter's patient_workplan_id
if not isnull(current_patient.open_encounter) and not isnull(current_service) then
	if upper(current_patient.open_encounter.encounter_status) = "OPEN" then
		if current_service.encounter_id = current_patient.open_encounter.encounter_id then
			ll_patient_workplan_id = current_patient.open_encounter.patient_workplan_id
			SELECT CAST(c_Workplan.id AS varchar(38))
			INTO :ls_current_workplan_guid
			FROM p_Patient_WP
				INNER JOIN c_Workplan
				ON p_Patient_WP.workplan_id = c_Workplan.workplan_id
			WHERE p_Patient_WP.cpr_id = :current_patient.cpr_id
			AND p_Patient_WP.patient_workplan_id = :ll_patient_workplan_id;
			if not tf_check() then setnull(ls_current_workplan_guid)
			if sqlca.sqlcode = 100 then setnull(ls_current_workplan_guid)
		end if
	end if
end if

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_u_chart_selection")
ll_rowcount = luo_data.retrieve()

setnull(ll_chart_id)

for i = 1 to ll_rowcount
	ls_user_id = luo_data.object.user_id[i]
	ls_specialty_id = luo_data.object.specialty_id[i]
	ls_workplan_guid = luo_data.object.workplan_guid[i]

	if not isnull(ls_user_id) then
		if user_list.is_user(ls_user_id) and ls_user_id <> current_user.user_id then continue
		if user_list.is_role(ls_user_id) and not user_list.is_user_role(current_user.user_id, ls_user_id) then continue
	end if
	
	if not isnull(ls_specialty_id) and ls_specialty_id <> current_user.specialty_id then continue
	
	if not isnull(ls_workplan_guid) then
		if isnull(ls_current_workplan_guid) then continue
		if ls_workplan_guid <> ls_current_workplan_guid then continue
	end if

	ll_chart_id = luo_data.object.chart_id[i]
	exit
next		

DESTROY luo_data

return ll_chart_id


end function

public subroutine closetab ();integer i

for i = 1 to section_count
	DESTROY section[i]
next

end subroutine

public function integer get_section_list ();string ls_user_id
u_user luo_user
long ll_section_id
long ll_last_section_id
integer li_page
integer i
long ll_rows
u_ds_data luo_data
long ll_progress_count

ll_progress_count = 0

current_service.get_attribute("chart_id", chart_id)
if isnull(chart_id) then
	// First, check the current user
	chart_id = get_chart_id()
	if chart_id <= 0 then return -1
end if

if isnull(chart_id) then return 0

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_data_chart_pages")

ll_rows = luo_data.retrieve(chart_id)
setnull(ll_last_section_id)


for i = 1 to ll_rows
	ll_section_id = luo_data.object.section_id[i]
	if isnull(ll_last_section_id) or (ll_last_section_id <> ll_section_id) then
		ll_last_section_id = ll_section_id
		section_count += 1
		section[section_count] = CREATE u_cpr_section
		section[section_count].my_cpr_main = parent
		section[section_count].chart_id = chart_id
		section[section_count].description = luo_data.object.section_description[i]
		section[section_count].section_id = luo_data.object.section_id[i]
		section[section_count].bitmap = luo_data.object.section_bitmap[i]
		section[section_count].tab_location = luo_data.object.tab_location[i]
		
		if upper(luo_data.object.default_flag[i]) = "Y" then
			section[section_count].default = true
		else
			section[section_count].default = false
		end if
		section[section_count].page_count = 0
	end if
	
	section[section_count].page_count += 1
	li_page = section[section_count].page_count
	section[section_count].page[li_page].page_id = luo_data.object.page_id[i]
	section[section_count].page[li_page].page_class = luo_data.object.page_class[i]
	
	// Swap out old SOAP tab for new if the main window has been expanded
	if lower(section[section_count].page[li_page].page_class) = "u_soap_page_assessments" &
	 and main_window.width > 3200 then
		section[section_count].page[li_page].page_class = "u_soap_page_problem_list"
	end if
	
	section[section_count].page[li_page].bitmap = luo_data.object.page_bitmap[i]
	section[section_count].page[li_page].description = luo_data.object.page_description[i]

	// Keep track of how many pages will be initialized before the user sees the chart
	if li_page = 1 or section[section_count].default then ll_progress_count += 1
next

DESTROY luo_data

// Initialize the progress bar
if isvalid(wait_window) then wait_window.initialize(0, (ll_progress_count * 2) + 3)

return section_count

end function

public function integer open_section_pages ();integer i
string ls_text


for i = 1 to section_count
	section[i].page_x = section[i].my_cpr_main.WorkSpaceX() + x + 15 - w_main.x
	section[i].page_y = section[i].my_cpr_main.WorkSpaceY() + y + 10 - w_main.y
	if section[i].page_count = 1 then
		TRY
			opentab(section[i].section_object, section[i].page[1].page_class, 0)
		CATCH (throwable lt_error)
			ls_text = "EncounterPRO encountered an error opening a chart page ("
			ls_text += section[i].page[1].page_class + ").  The following error message was returned:  "
			ls_text += lt_error.text
			log.log(this, "u_cpr_tab.open_section_pages:0015", ls_text, 4)
			chart_window.event POST load_error("EncounterPRO encountered an error opening the chart")
			return -1
		END TRY
	else
		opentab(section[i].section_object, "u_cpr_multi_page_section", 0)
	end if
	
	section[i].section_object.tabbackcolor = color_object
	section[i].section_object.text = section[i].description
	section[i].section_object.picturename = section[i].bitmap
	section[i].section_object.wait_window = wait_window
	section[i].section_object.chart_window = chart_window

	if isvalid(wait_window) then wait_window.bump_progress()
next

for i = 1 to section_count
	TRY
		section[i].section_object.initialize(section[i], 1)
	CATCH (throwable lt_error2)
		ls_text = "EncounterPRO encountered an error initializing a chart page ("
		ls_text += section[i].page[1].page_class + ").  The following error message was returned:  "
		ls_text += lt_error2.text
		log.log(this, "u_cpr_tab.open_section_pages:0039", ls_text, 4)
		chart_window.event POST load_error("EncounterPRO encountered an error initializing the chart")
		return -1
	END TRY
	
	if isvalid(wait_window) then wait_window.bump_progress()
next

log.log(this, "u_cpr_tab.open_section_pages:0047", "Finished opening sections", 1)

return 1

end function

event selectionchanging;integer li_sts
long ll_null
string ls_null
integer li_null

setnull(ll_null)
setnull(ls_null)
setnull(li_null)

if initializing and newindex = 1 then
	initializing = false
	return 1
end if

selectionchanging = true

if oldindex > 0 and oldindex <> newindex then
	section[oldindex].section_object.tabbackcolor = color_object
	section[oldindex].section_object.triggerevent("tablostfocus")
end if

section[newindex].section_object.tabbackcolor = color_object_selected

li_sts = f_set_progress3( current_patient.cpr_id, &
								"Patient", &
								ll_null, &
								"User View", &
								 "Chart Tab", &
								section[newindex].description, & 
								datetime(today(), now()), & 
								ll_null, & 
								ll_null, & 
								current_service.patient_workplan_item_id, & 
								li_null, & 
								ls_null, & 
								current_user.user_id)

section[newindex].section_selected()

if section[newindex].section_object.tag = "EXIT" and current_service.manual_service then
	section[newindex].my_cpr_main.close("CLOSE")
end if
//if section[newindex].section_object.tag = "EXIT" then
//	yield()
//	li_sts = w_cpr_main.close()
//	if li_sts = 0 then
//		if oldindex > 0 then
//			section[oldindex].section_object.tabbackcolor = color_object_selected
//		end if
//		section[newindex].section_object.tabbackcolor = color_object
//		return 1
//	end if
//end if

end event

event key;
// pass the keystroke into the tab
if selectedtab > 0 then
	section[selectedtab].section_object.key_down(key, keyflags)
end if

end event

event getfocus;if selectedtab > 0 then
	section[selectedtab].section_object.setfocus()
end if

end event

