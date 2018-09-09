$PBExportHeader$u_location_domain_list.sru
forward
global type u_location_domain_list from nonvisualobject
end type
type str_observation_type from structure within u_location_domain_list
end type
end forward

type str_observation_type from structure
    string observation_type
    string description
end type

shared variables

end variables

global type u_location_domain_list from nonvisualobject
event retrieve_exams pbm_custom01
event retrieve_encounter pbm_custom02
event save_results pbm_custom03
end type
global u_location_domain_list u_location_domain_list

type variables
integer location_domain_count = 0
u_str_location_domain loc_domain[]

end variables

forward prototypes
public function u_str_location_domain find_location_domain (string ps_location_domain)
public function string get_location_description (string ps_location_domain, string ps_location)
public function u_str_location find_location (string ps_location_domain, string ps_location)
public function u_str_location_domain add_location_domain (string ps_location_domain, string ps_description)
public function integer load_location_domains ()
end prototypes

public function u_str_location_domain find_location_domain (string ps_location_domain);integer i
u_str_location_domain null_location_domain
string ls_description

setnull(null_location_domain)

for i = 1 to location_domain_count
	if loc_domain[i].location_domain = ps_location_domain then return loc_domain[i]
next

SELECT description
INTO :ls_description
FROM c_Location_Domain
WHERE location_domain = :ps_location_domain;
if not tf_check() then return null_location_domain
if sqlca.sqlcode = 100 then return null_location_domain

// If we found the new location domain then add it
add_location_domain( &
		ps_location_domain, &
		ls_description &
		)

loc_domain[location_domain_count].load_locations()

return loc_domain[location_domain_count]


end function

public function string get_location_description (string ps_location_domain, string ps_location);u_str_location_domain luo_location_domain
u_str_location luo_location
string ls_null

luo_location_domain = find_location_domain(ps_location_domain)
if not isnull(luo_location_domain) then
	luo_location = luo_location_domain.find_location(ps_location)
	if not isnull(luo_location) then return luo_location.description
end if

setnull(ls_null)
return ls_null

end function

public function u_str_location find_location (string ps_location_domain, string ps_location);u_str_location_domain luo_location_domain
u_str_location luo_location

luo_location_domain = find_location_domain(ps_location_domain)
if not isnull(luo_location_domain) then return luo_location_domain.find_location(ps_location)

setnull(luo_location)
return luo_location

end function

public function u_str_location_domain add_location_domain (string ps_location_domain, string ps_description);location_domain_count += 1
loc_domain[location_domain_count] = CREATE u_str_location_domain

loc_domain[location_domain_count].location_domain = ps_location_domain
loc_domain[location_domain_count].description = ps_description

return loc_domain[location_domain_count]
end function

public function integer load_location_domains ();string ls_location_domain
string ls_description
integer li_rowcount, i, j
long ll_rows
u_ds_data luo_data

luo_data = CREATE u_ds_data

string ls_last_location_domain = ""

// by sumathi chinnasamy
luo_data.set_dataobject("dw_location_domains")
tf_begin_transaction(this, "retrieve_location_domains()")
ll_rows = luo_data.retrieve()
tf_commit()

li_rowcount = luo_data.rowcount()

for i = 1 to li_rowcount
	ls_location_domain = luo_data.object.c_location_domain_location_domain[i]
	ls_description = luo_data.object.c_location_domain_description[i]

	if ls_last_location_domain <> ls_location_domain then
		ls_last_location_domain = ls_location_domain
		add_location_domain( &
				ls_location_domain, &
				ls_description &
				)
	end if
next

for i = 1 to location_domain_count
	loc_domain[i].load_locations()
next

log.log(this, "u_location_domain_list.load_location_domains:0036", "Locations Loaded", 1)

DESTROY luo_data

return 1
end function

on u_location_domain_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_location_domain_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

