$PBExportHeader$u_str_location_domain.sru
forward
global type u_str_location_domain from nonvisualobject
end type
end forward

global type u_str_location_domain from nonvisualobject
end type
global u_str_location_domain u_str_location_domain

type variables
string location_domain
string description

integer location_count
u_str_location location[]
end variables

forward prototypes
public function u_str_location find_location (string ps_location)
public function integer find_location_index (string ps_location)
public function boolean has_diffuse_location ()
public subroutine add_location (string ps_location, string ps_description, integer pi_sort_sequence, string ps_diffuse_flag, string ps_status)
public function integer initialize (string ps_location_domain)
public function integer load_locations ()
end prototypes

public function u_str_location find_location (string ps_location);integer i
u_str_location null_location
string ls_description
integer li_sort_sequence
string ls_diffuse_flag
string ls_status

setnull(null_location)

for i = 1 to location_count
	if location[i].location = ps_location then return location[i]
next

SELECT description,
		 sort_sequence,
		 diffuse_flag,
		 status
INTO :ls_description,
	  :li_sort_sequence,
	  :ls_diffuse_flag,
	  :ls_status
FROM c_Location
WHERE location_domain = :location_domain
AND location = :ps_location;
if not tf_check() then return null_location
if sqlca.sqlcode = 100 then return null_location

// If we found the new location domain then add it
add_location( &
	ps_location, &
	ls_description, &
	li_sort_sequence, &
	ls_diffuse_flag, &
	ls_status)

return location[location_count]


end function

public function integer find_location_index (string ps_location);integer i
string ls_description
integer li_sort_sequence
string ls_diffuse_flag
string ls_status

for i = 1 to location_count
	if location[i].location = ps_location then return i
next

SELECT description,
		 sort_sequence,
		 diffuse_flag,
		 status
INTO :ls_description,
	  :li_sort_sequence,
	  :ls_diffuse_flag,
	  :ls_status
FROM c_Location
WHERE location_domain = :location_domain
AND location = :ps_location;
if not tf_check() then return 0
if sqlca.sqlcode = 100 then return 0

// If we found the new location domain then add it
add_location( &
	ps_location, &
	ls_description, &
	li_sort_sequence, &
	ls_diffuse_flag, &
	ls_status)

return location_count


end function

public function boolean has_diffuse_location ();integer i

for i = 1 to location_count
	if location[i].diffuse_flag = "Y" then return true
next

return false

end function

public subroutine add_location (string ps_location, string ps_description, integer pi_sort_sequence, string ps_diffuse_flag, string ps_status);location_count += 1
location[location_count] = CREATE u_str_location

location[location_count].location_index = location_count
location[location_count].location = ps_location
location[location_count].description = ps_description
location[location_count].sort_sequence = pi_sort_sequence
location[location_count].diffuse_flag = ps_diffuse_flag
location[location_count].status = ps_status

location[location_count].parent_location_domain = this


end subroutine

public function integer initialize (string ps_location_domain);

if isnull(ps_location_domain) then
	log.log(this, "u_str_location_domain.initialize:0004", "null location domain", 4)
	return -1
end if

location_domain = ps_location_domain

SELECT description
INTO :description
FROM c_Location_Domain
WHERE location_domain = :ps_location_domain;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_str_location_domain.initialize:0016", "location domain not found (" + ps_location_domain + ")", 4)
	return -1
end if

return load_locations()

end function

public function integer load_locations ();integer i
string ls_location
string ls_location_description
integer li_sort_sequence
string ls_diffuse_flag
string ls_status
long ll_rows
u_ds_data luo_data

u_ds_data = CREATE u_ds_data
u_ds_data.set_dataobject("dw_data_location_list")

ll_rows = u_ds_data.retrieve(location_domain)

for i = 1 to ll_rows
	ls_location = u_ds_data.object.location[i]
	ls_location_description = u_ds_data.object.description[i]
	li_sort_sequence = u_ds_data.object.sort_sequence[i]
	ls_diffuse_flag = u_ds_data.object.diffuse_flag[i]
	ls_status = u_ds_data.object.status[i]
	
	add_location( &
		ls_location, &
		ls_location_description, &
		li_sort_sequence, &
		ls_diffuse_flag, &
		ls_status)
next

DESTROY u_ds_data

return ll_rows


end function

on u_str_location_domain.create
TriggerEvent( this, "constructor" )
end on

on u_str_location_domain.destroy
TriggerEvent( this, "destructor" )
end on

