﻿$PBExportHeader$u_vaccine_list.sru
forward
global type u_vaccine_list from nonvisualobject
end type
end forward

global type u_vaccine_list from nonvisualobject
end type
global u_vaccine_list u_vaccine_list

type variables
integer vaccine_count
u_str_vaccine vaccine[]
end variables

forward prototypes
public function integer get_vaccine_index (string ps_vaccine_id)
public function integer load_vaccines ()
public function integer get_vaccine_from_proc (string ps_procedure_id)
public subroutine add_vaccine (string ps_vaccine_id, string ps_description, string ps_drug_id)
end prototypes

public function integer get_vaccine_index (string ps_vaccine_id);integer i
string ls_description, ls_drug_id

for i = 1 to vaccine_count
	if vaccine[i].vaccine_id = ps_vaccine_id then
		return i
	end if
next

SELECT description, drug_id
INTO :ls_description, :ls_drug_id
FROM c_Vaccine
WHERE vaccine_id = :ps_vaccine_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

add_vaccine(ps_vaccine_id, ls_description, ls_drug_id)

return vaccine_count

end function

public function integer load_vaccines ();string ls_description
string ls_vaccine_id
string ls_drug_id
integer i
boolean lb_loop

 DECLARE lc_schedule CURSOR FOR  
  SELECT vaccine_id,
			description,
			drug_id
    FROM c_Vaccine
 ORDER BY	c_Vaccine.vaccine_id;

log.log(this, "u_vaccine_list.load_vaccines:0012", "Loading vaccines...", 1)

tf_begin_transaction(this, "")

OPEN lc_schedule;
if not tf_check() then return -1

lb_loop = true
vaccine_count = 0

DO
	FETCH lc_schedule
	INTO	:ls_vaccine_id,
			:ls_description,
			:ls_drug_id;
	if not tf_check() then return -1

	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		add_vaccine	(	ls_vaccine_id, &
							ls_description, &
							ls_drug_id &
						)
	else
		lb_loop = false
	end if

LOOP while lb_loop

CLOSE lc_schedule;

tf_commit()

log.log(this, "u_vaccine_list.load_vaccines:0042", "Vaccines loaded", 1)

return 1

end function

public function integer get_vaccine_from_proc (string ps_procedure_id);integer i
string ls_vaccine_id

SELECT vaccine_id
INTO :ls_vaccine_id
FROM c_Procedure (NOLOCK)
WHERE procedure_id = :ps_procedure_id;
if not tf_check() then return -1

if sqlca.sqlcode = 100 then return 0

return get_vaccine_index(ls_vaccine_id)

end function

public subroutine add_vaccine (string ps_vaccine_id, string ps_description, string ps_drug_id);vaccine_count = vaccine_count + 1
vaccine[vaccine_count] = CREATE u_str_vaccine

vaccine[vaccine_count].vaccine_id = ps_vaccine_id
vaccine[vaccine_count].description = ps_description
vaccine[vaccine_count].drug_id = ps_drug_id

end subroutine

on u_vaccine_list.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_vaccine_list.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

