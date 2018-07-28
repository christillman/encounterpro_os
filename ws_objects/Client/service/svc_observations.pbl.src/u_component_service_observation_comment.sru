$PBExportHeader$u_component_service_observation_comment.sru
forward
global type u_component_service_observation_comment from u_component_service
end type
end forward

global type u_component_service_observation_comment from u_component_service
end type
global u_component_service_observation_comment u_component_service_observation_comment

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();str_popup_return popup_return
str_popup popup
long ll_observation_sequence
string ls_observation_id
string ls_treatment_type
string ls_comment_title
string ls_observation_tag
str_observation_comment lstr_comment
integer li_sts
string ls_description
long ll_attachment_id
string ls_action
long ll_observation_comment_id
string ls_component_id
u_component_attachment luo_attachment
boolean lb_display
boolean lb_edit
boolean lb_transcribe
string lsa_actions[]

// Make sure we have a treatment object
if isnull(treatment) then return 1

// See if an observation_sequence has been specified
ll_observation_sequence = long(get_attribute("observation_sequence"))
if isnull(ll_observation_sequence) then ll_observation_sequence = get_root_observation()

// Now get the observation_id from the observation_sequence
ls_observation_id = treatment.get_observation_id(ll_observation_sequence)
if isnull(ls_observation_id) then ls_observation_id = "!DEFAULT"

// Get the comment title
ls_comment_title = get_attribute("comment_title")

get_attribute("observation_comment_id", ll_observation_comment_id)
if isnull(ll_observation_comment_id) and isnull(ls_comment_title) then
	// If we don't already have an observation_comment_id, then we must be creating a new comment
	// In that case, get a comment_title from the user
	popup.title = "Please enter a comment title or select one from the list below"
	popup.argument_count = 2
	popup.argument[1] = ls_observation_id
	popup.argument[2] = treatment.treatment_type
	popup.multiselect = false
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then
		if manual_service then
			return 1
		else
			popup.data_row_count = 2
			popup.items[1] = "I'll Be Back"
			popup.items[2] = "I'm Finished"
			popup.argument_count = 0
			openwithparm(w_pop_pick, popup)
			popup_return = message.powerobjectparm
			if popup_return.item_count <> 1 then
				return 0
			else
				if popup_return.item_indexes[1] = 1 then
					return 0
				else
					return 1
				end if
			end if
		end if
	end if
	
	ls_comment_title = trim(popup_return.items[1])
	add_attribute("comment_title", ls_comment_title)
end if


ls_action = "Comment"

// See if there is an existing comment for this observation/user/comment_title
li_sts = treatment.get_comment(ll_observation_sequence, ls_comment_title, lstr_comment)
if li_sts > 0 then
	// We already have a comment.  See if it's an attachment
	if not isnull(lstr_comment.attachment_id) then
		ll_attachment_id = lstr_comment.attachment_id
		SELECT e.description, e.component_id
		INTO :ls_description, :ls_component_id
		FROM p_Attachment a, c_Attachment_Extension e
		WHERE a.extension = e.extension
		AND a.attachment_id = :ll_attachment_id
		USING cprdb;
		if not cprdb.check() then return -1
		if cprdb.sqlcode = 100 then ls_description = "Attachment"
		
		if isnull(ls_component_id) then ls_component_id = "ATCH_GENERIC"
		
		luo_attachment = component_manager.get_component(ls_component_id)
		if not isnull(luo_attachment) then
			lb_display = luo_attachment.is_displayable()
			lb_edit = luo_attachment.is_editable()
			lb_transcribe = luo_attachment.is_transcribeable()
			
			component_manager.destroy_component(luo_attachment)
		end if
		
		// The last comment is an attachment so see what the user wants to do
		popup.data_row_count = 0
		popup.title = "Do you wish to..."
		
		if lb_display then
			popup.data_row_count += 1
			popup.items[popup.data_row_count] = "Display " + ls_description
			lsa_actions[popup.data_row_count] = "Display"
		end if
		
		if lb_edit then
			popup.data_row_count += 1
			popup.items[popup.data_row_count] = "Edit " + ls_description
			lsa_actions[popup.data_row_count] = "Edit"

		end if
		
		if lb_transcribe then
			popup.data_row_count += 1
			popup.items[popup.data_row_count] = "Transcribe " + ls_description
			lsa_actions[popup.data_row_count] = "Transcribe"
		end if
		
		popup.auto_singleton = true
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return 0
		ls_action = lsa_actions[popup_return.item_indexes[1]]
	end if
end if

CHOOSE CASE ls_action
	CASE "Comment"
		Openwithparm(service_window, this, "w_observation_comment_with_list")
		popup_return = Message.Powerobjectparm
		If popup_return.item_count <> 1 Then Return 0
		
		If popup_return.items[1] = "CLOSE" Then
			li_sts = 1
		ElseIf popup_return.items[1] = "CANCEL" Then
			li_sts = 2
		Else
			li_sts = 0
		End If
	CASE "Display"
		li_sts = f_display_attachment(ll_attachment_id)
		if li_sts <= 0 then
			li_sts = 0
		else
			li_sts = 1
		end if
	CASE "Edit"
		li_sts = f_edit_attachment(ll_attachment_id)
		if li_sts <= 0 then
			li_sts = 0
		else
			li_sts = 1
		end if
	CASE "Transcribe"
		li_sts = f_transcribe_attachment(ll_attachment_id)
		if li_sts <= 0 then
			li_sts = 0
		else
			li_sts = 1
		end if
	CASE ELSE
		li_sts = 0
END CHOOSE

return li_sts



end function

on u_component_service_observation_comment.create
call super::create
end on

on u_component_service_observation_comment.destroy
call super::destroy
end on

