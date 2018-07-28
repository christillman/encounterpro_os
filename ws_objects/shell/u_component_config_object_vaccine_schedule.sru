HA$PBExportHeader$u_component_config_object_vaccine_schedule.sru
forward
global type u_component_config_object_vaccine_schedule from u_component_config_object
end type
end forward

global type u_component_config_object_vaccine_schedule from u_component_config_object
end type
global u_component_config_object_vaccine_schedule u_component_config_object_vaccine_schedule

forward prototypes
public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data)
public function integer install (string ps_config_object_id, long pl_version)
end prototypes

public function integer encapsulate (str_config_object_info pstr_config_object, ref blob pbl_config_object_data);
SELECTBLOB dbo.fn_config_image(:pstr_config_object.config_object_id)
INTO :pbl_config_object_data
FROM c_1_Record;
if not tf_check() then return -1

return 1

end function

public function integer install (string ps_config_object_id, long pl_version);long ll_sts
integer li_sts

if isnull(ps_config_object_id) then
	log.log(this, "f_config_object_install_sql()", "config_object_id is null", 4)
	return -1
end if

if isnull(pl_version) then
	log.log(this, "f_config_object_install_sql()", "Version is null", 4)
	return -1
end if

ll_sts = sqlca.config_install_object(ps_config_object_id, pl_version)
if not tf_check() then return -1
if ll_sts <= 0 then return -1


return 1

end function

on u_component_config_object_vaccine_schedule.create
call super::create
end on

on u_component_config_object_vaccine_schedule.destroy
call super::destroy
end on

