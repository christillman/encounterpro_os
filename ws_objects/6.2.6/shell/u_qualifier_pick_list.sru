HA$PBExportHeader$u_qualifier_pick_list.sru
forward
global type u_qualifier_pick_list from UserObject
end type
type cb_down from commandbutton within u_qualifier_pick_list
end type
type st_title from statictext within u_qualifier_pick_list
end type
type dw_qualifiers from u_dw_pick_list within u_qualifier_pick_list
end type
end forward

global type u_qualifier_pick_list from UserObject
int Width=795
int Height=1188
long BackColor=33538240
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
cb_down cb_down
st_title st_title
dw_qualifiers dw_qualifiers
end type
global u_qualifier_pick_list u_qualifier_pick_list

type variables
string cpr_id
long encounter_id
long treatment_id
string observation_id
string location
integer result_sequence
long qualifier_domain_id
string prefix

u_ds_data selected_qualifiers

end variables

forward prototypes
public subroutine clear_selected ()
public function integer initialize (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, long pl_qualifier_domain_id, string ps_title, string ps_prefix, string ps_exclusive_flag, u_ds_data puo_qualifiers)
end prototypes

public subroutine clear_selected ();dw_qualifiers.clear_selected()

end subroutine

public function integer initialize (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, long pl_qualifier_domain_id, string ps_title, string ps_prefix, string ps_exclusive_flag, u_ds_data puo_qualifiers);long ll_count
long i
long ll_row
long ll_row2
string ls_qualifier
string ls_find
string ls_find2
integer li_found
long ll_selected_count

// Initialize instance variables
cpr_id = ps_cpr_id
encounter_id = pl_encounter_id
treatment_id = pl_treatment_id
observation_id = ps_observation_id
location = ps_location
result_sequence = pi_result_sequence
qualifier_domain_id = pl_qualifier_domain_id
prefix = ps_prefix

// Set the title
st_title.text = ps_title

// Display the list of qualifiers in this domain
dw_qualifiers.settransobject(sqlca)
ll_count = dw_qualifiers.retrieve(qualifier_domain_id)

// save the datastore of selected qualifiers and count them
selected_qualifiers = puo_qualifiers
ll_selected_count = selected_qualifiers.rowcount()


// Now loop through the selected qualifiers and find all the qualifiers
// in this qualifier domain.
ls_find = "qualifier_domain_id=" + string(qualifier_domain_id)
ll_row = selected_qualifiers.find(ls_find, 1, ll_selected_count)
li_found = 0
DO WHILE ll_row > 0 and ll_row <= ll_selected_count
	// For each selected qualifier in this domain, find it's record in the datawindow
	ls_qualifier = selected_qualifiers.object.qualifier[ll_row]
	ls_find2 = "qualifier='" + ls_qualifier + "'"
	ll_row2 = dw_qualifiers.find(ls_find2, 1, ll_count)
	
	// If we found one, then mark it as selected
	if ll_row2 > 0 then
		dw_qualifiers.object.selected_flag[ll_row2] = 1
		li_found += 1
	end if
	
	// Get next record from selected_qualifiers
	ll_row = dw_qualifiers.find(ls_find, ll_row + 1, ll_count + 1)
LOOP

if ps_exclusive_flag = "Y" then
	dw_qualifiers.multiselect = false
else
	dw_qualifiers.multiselect = true
end if

dw_qualifiers.set_page(1, cb_down.text)
if dw_qualifiers.last_page <= 1 then
	cb_down.visible = false
else
	cb_down.visible = true
end if

return li_found


end function

on u_qualifier_pick_list.create
this.cb_down=create cb_down
this.st_title=create st_title
this.dw_qualifiers=create dw_qualifiers
this.Control[]={this.cb_down,&
this.st_title,&
this.dw_qualifiers}
end on

on u_qualifier_pick_list.destroy
destroy(this.cb_down)
destroy(this.st_title)
destroy(this.dw_qualifiers)
end on

event constructor;dw_qualifiers.settransobject(sqlca)

end event

type cb_down from commandbutton within u_qualifier_pick_list
int X=407
int Y=1092
int Width=375
int Height=96
int TabOrder=20
string Text="page 99/99"
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;dw_qualifiers.set_page(dw_qualifiers.current_page + 1, text)

end event

type st_title from statictext within u_qualifier_pick_list
int Width=800
int Height=140
boolean Enabled=false
string Text="none"
Alignment Alignment=Center!
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=33538240
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type dw_qualifiers from u_dw_pick_list within u_qualifier_pick_list
int X=0
int Y=148
int Width=809
int Height=936
int TabOrder=10
string DataObject="dw_qualifier_display_list"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event selected;call super::selected;integer li_sts
string ls_find
string ls_qualifier
long ll_row

ls_qualifier = object.qualifier[selected_row]

ls_find = "qualifier_domain_id=" + string(qualifier_domain_id)
ls_find += " and qualifier='" + ls_qualifier + "'"
ll_row = selected_qualifiers.find(ls_find, 1, selected_qualifiers.rowcount())
if ll_row <= 0 then
	ll_row = selected_qualifiers.insertrow(0)
	selected_qualifiers.object.cpr_id[ll_row] = cpr_id
	selected_qualifiers.object.encounter_id[ll_row] = encounter_id
	selected_qualifiers.object.treatment_id[ll_row] = treatment_id
	selected_qualifiers.object.observation_id[ll_row] = observation_id
	selected_qualifiers.object.location[ll_row] = location
	selected_qualifiers.object.result_sequence[ll_row] = result_sequence
	selected_qualifiers.object.qualifier_domain_id[ll_row] = qualifier_domain_id
	selected_qualifiers.object.qualifier[ll_row] = ls_qualifier
	selected_qualifiers.object.prefix[ll_row] = prefix
	selected_qualifiers.object.created_by[ll_row] = current_scribe.user_id
	selected_qualifiers.object.created[ll_row] = datetime(today(), now())
	li_sts = selected_qualifiers.update()
end if



end event

event unselected;call super::unselected;integer li_sts
string ls_find
string ls_qualifier
long ll_row

ls_qualifier = object.qualifier[unselected_row]

ls_find = "qualifier_domain_id=" + string(qualifier_domain_id)
ls_find += " and qualifier='" + ls_qualifier + "'"
ll_row = selected_qualifiers.find(ls_find, 1, selected_qualifiers.rowcount())
if ll_row > 0 then
	selected_qualifiers.deleterow(ll_row)
	li_sts = selected_qualifiers.update()
end if



end event

