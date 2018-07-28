$PBExportHeader$u_str_development_stage.sru
forward
global type u_str_development_stage from nonvisualobject
end type
end forward

global type u_str_development_stage from nonvisualobject
end type
global u_str_development_stage u_str_development_stage

type variables
string stage_id
string description
real age_months
integer sort_order
string well_assessment_id
string new_procedure_id
string est_procedure_id
string medicaid_normal_procedure_id
string medicaid_abnormal_procedure_id

integer item_count
u_str_development_item item[]

end variables

forward prototypes
public subroutine add_item (string ps_item_type, integer pi_item_sequence, string ps_description)
public function u_str_development_item find_item (string ps_item_type, integer pi_item_sequence)
public function integer get_item_index (string ps_item_type, integer pi_item_sequence)
end prototypes

public subroutine add_item (string ps_item_type, integer pi_item_sequence, string ps_description);
item_count = item_count + 1
item[item_count] = CREATE u_str_development_item

item[item_count].item_type = ps_item_type
item[item_count].item_sequence = pi_item_sequence
item[item_count].description = ps_description

item[item_count].parent_stage = this



end subroutine

public function u_str_development_item find_item (string ps_item_type, integer pi_item_sequence);integer i
u_str_development_item luo_null

for i = 1 to item_count
	if item[i].item_type = ps_item_type &
			and item[i].item_sequence = pi_item_sequence then return item[i]
next

setnull(luo_null)
return luo_null


end function

public function integer get_item_index (string ps_item_type, integer pi_item_sequence);integer i

for i = 1 to item_count
	if item[i].item_type = ps_item_type &
			and item[i].item_sequence = pi_item_sequence then return i
next

return 0


end function

on u_str_development_stage.create
TriggerEvent( this, "constructor" )
end on

on u_str_development_stage.destroy
TriggerEvent( this, "destructor" )
end on

