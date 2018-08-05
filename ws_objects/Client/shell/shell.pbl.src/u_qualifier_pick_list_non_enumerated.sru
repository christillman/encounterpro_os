$PBExportHeader$u_qualifier_pick_list_non_enumerated.sru
forward
global type u_qualifier_pick_list_non_enumerated from UserObject
end type
type cb_down from commandbutton within u_qualifier_pick_list_non_enumerated
end type
type st_title from statictext within u_qualifier_pick_list_non_enumerated
end type
type dw_qualifiers from u_dw_pick_list within u_qualifier_pick_list_non_enumerated
end type
end forward

global type u_qualifier_pick_list_non_enumerated from UserObject
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
global u_qualifier_pick_list_non_enumerated u_qualifier_pick_list_non_enumerated

type variables
string cpr_id
long encounter_id
long treatment_id
string observation_id
string location
integer result_sequence

u_ds_data selected_qualifiers

long last_row = 0
string last_qualifier = ""
end variables

forward prototypes
public subroutine clear_selected ()
public function integer initialize (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, string ps_title, u_ds_data puo_qualifiers)
public function string get_qualifier (long pl_qualifier_domain_id, string ps_description, string ps_last_qualifier)
end prototypes

public subroutine clear_selected ();dw_qualifiers.clear_selected()

end subroutine

public function integer initialize (string ps_cpr_id, long pl_encounter_id, long pl_treatment_id, string ps_observation_id, string ps_location, integer pi_result_sequence, string ps_title, u_ds_data puo_qualifiers);long ll_count
long i
long ll_row
long ll_row2
string ls_qualifier
string ls_find
string ls_find2
long ll_selected_count
long ll_qualifier_domain_id

// Initialize instance variables
cpr_id = ps_cpr_id
encounter_id = pl_encounter_id
treatment_id = pl_treatment_id
observation_id = ps_observation_id
location = ps_location
result_sequence = pi_result_sequence

dw_qualifiers.multiselect = true

// Set the title
st_title.text = ps_title

// Display the list of qualifiers in this domain
dw_qualifiers.settransobject(sqlca)
ll_count = dw_qualifiers.retrieve(observation_id, result_sequence)
if ll_count <= 0 then return ll_count

// save the datastore of selected qualifiers and count them
selected_qualifiers = puo_qualifiers
ll_selected_count = selected_qualifiers.rowcount()


// Now loop through the qualifier list and see if it's been selected
for i = 1 to ll_count
	ll_qualifier_domain_id = dw_qualifiers.object.qualifier_domain_id[i]
	ls_find = "qualifier_domain_id=" + string(ll_qualifier_domain_id)
	ll_row = selected_qualifiers.find(ls_find, 1, ll_selected_count)
	if ll_row > 0 then
		dw_qualifiers.object.selected_flag[i] = 1
		dw_qualifiers.object.qualifier[i] = selected_qualifiers.object.qualifier[ll_row]
	end if
next

dw_qualifiers.set_page(1, cb_down.text)
if dw_qualifiers.last_page <= 1 then
	cb_down.visible = false
else
	cb_down.visible = true
end if

return ll_count



end function

public function string get_qualifier (long pl_qualifier_domain_id, string ps_description, string ps_last_qualifier);str_popup popup
str_popup_return popup_return
long ll_qualifier_domain_category_id
string ls_null
string ls_qualifier_class
string ls_qualifier
date ld_date

ld_date = today()
setnull(ls_null)

ll_qualifier_domain_category_id = datalist.qualifier_domain_category_id(pl_qualifier_domain_id)
if isnull(ll_qualifier_domain_category_id) then return ls_null

ls_qualifier_class = datalist.qualifier_class(ll_qualifier_domain_category_id)
if isnull(ls_qualifier_class) then return ls_null

CHOOSE CASE ls_qualifier_class
	CASE "DATE"
		ls_qualifier = f_select_date(ld_date, ps_description)
//		popup.title = ps_description
//		openwithparm(w_pop_prompt_date, popup)
//		popup_return = message.powerobjectparm
//		if popup_return.item_count <> 1 then return ls_null
//		ls_qualifier = popup_return.items[1]
	CASE "TEXT"
		popup.title = ps_description
		popup.item = ps_last_qualifier
		openwithparm(w_pop_prompt_string, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return ls_null
		ls_qualifier = popup_return.items[1]
	CASE ELSE
		log.log(this, "u_qualifier_pick_list_non_enumerated.get_qualifier:0034", "Invalid qualifier class (" + ls_qualifier_class + ")", 4)
		return ls_null
END CHOOSE

return ls_qualifier

end function

on u_qualifier_pick_list_non_enumerated.create
this.cb_down=create cb_down
this.st_title=create st_title
this.dw_qualifiers=create dw_qualifiers
this.Control[]={this.cb_down,&
this.st_title,&
this.dw_qualifiers}
end on

on u_qualifier_pick_list_non_enumerated.destroy
destroy(this.cb_down)
destroy(this.st_title)
destroy(this.dw_qualifiers)
end on

event constructor;dw_qualifiers.settransobject(sqlca)

end event

type cb_down from commandbutton within u_qualifier_pick_list_non_enumerated
int X=434
int Y=1088
int Width=347
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

type st_title from statictext within u_qualifier_pick_list_non_enumerated
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

type dw_qualifiers from u_dw_pick_list within u_qualifier_pick_list_non_enumerated
int X=0
int Y=148
int Width=809
int Height=936
int TabOrder=10
string DataObject="dw_qualifier_display_list_non_enumerated"
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

event selected;call super::selected;integer li_sts
string ls_find
string ls_old_qualifier
string ls_new_qualifier
long ll_row
long ll_qualifier_domain_id
string ls_description

ll_qualifier_domain_id = object.qualifier_domain_id[selected_row]
ls_old_qualifier = object.qualifier[selected_row]
ls_description = object.description[selected_row]

if selected_row <> last_row then last_qualifier = ""

ls_new_qualifier = get_qualifier(ll_qualifier_domain_id, ls_description, last_qualifier)
if isnull(ls_new_qualifier) then
	object.selected_flag[selected_row] = 0
	return
end if

if len(ls_new_qualifier) > 40 then
	openwithparm(w_pop_message, "Qualifier has been truncated to 40 characters")
	ls_new_qualifier = left(ls_new_qualifier, 40)
end if

object.qualifier[selected_row] = ls_new_qualifier

ls_find = "qualifier_domain_id=" + string(ll_qualifier_domain_id)
ls_find += " and qualifier='" + ls_old_qualifier + "'"
ll_row = selected_qualifiers.find(ls_find, 1, selected_qualifiers.rowcount())
if ll_row > 0 then
	selected_qualifiers.object.qualifier[ll_row] = ls_new_qualifier
	li_sts = selected_qualifiers.update()
else
	ll_row = selected_qualifiers.insertrow(0)
	selected_qualifiers.object.cpr_id[ll_row] = cpr_id
	selected_qualifiers.object.encounter_id[ll_row] = encounter_id
	selected_qualifiers.object.treatment_id[ll_row] = treatment_id
	selected_qualifiers.object.observation_id[ll_row] = observation_id
	selected_qualifiers.object.location[ll_row] = location
	selected_qualifiers.object.result_sequence[ll_row] = result_sequence
	selected_qualifiers.object.qualifier_domain_id[ll_row] = ll_qualifier_domain_id
	selected_qualifiers.object.qualifier[ll_row] = ls_new_qualifier
	selected_qualifiers.object.created_by[ll_row] = current_scribe.user_id
	selected_qualifiers.object.created[ll_row] = datetime(today(), now())
	li_sts = selected_qualifiers.update()
end if



end event

event unselected;call super::unselected;integer li_sts
string ls_find
string ls_qualifier
long ll_row
long ll_qualifier_domain_id
string ls_null

setnull(ls_null)

last_row = unselected_row
last_qualifier = object.qualifier[unselected_row]

ll_qualifier_domain_id = object.qualifier_domain_id[unselected_row]
ls_qualifier = object.qualifier[unselected_row]

object.qualifier[unselected_row] = ls_null

ls_find = "qualifier_domain_id=" + string(ll_qualifier_domain_id)
ls_find += " and qualifier='" + ls_qualifier + "'"
ll_row = selected_qualifiers.find(ls_find, 1, selected_qualifiers.rowcount())
if ll_row > 0 then
	selected_qualifiers.deleterow(ll_row)
	li_sts = selected_qualifiers.update()
end if



end event

