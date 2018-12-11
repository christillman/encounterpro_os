$PBExportHeader$u_component_reportserver.sru
forward
global type u_component_reportserver from u_component_base_class
end type
end forward

global type u_component_reportserver from u_component_base_class
end type
global u_component_reportserver u_component_reportserver

type variables
datastore report_queue
end variables

forward prototypes
private subroutine mark_error (long pl_report_key)
public function integer xx_initialize ()
private function str_attributes get_report_queue_attributes (long pl_report_key)
public function integer timer_ding ()
end prototypes

private subroutine mark_error (long pl_report_key);
mylog.log(this, "u_component_reportserver.mark_error:0002", "Marking report with error status (" + string(pl_report_key) + ")", 3)

cprdb.begin_transaction(this, "mark_error()")

UPDATE o_report_queue
SET report_status = 'ERROR'
WHERE report_key = :pl_report_key
USING cprdb;
if not tf_check() then return

cprdb.commit_transaction()


end subroutine

public function integer xx_initialize ();integer li_sts
string ls_temp

li_sts = f_initialize_objects()
if li_sts <= 0 then
	mylog.log(this, "u_component_reportserver.xx_initialize:0006", "Error initializing objects", 4)
	return -1
end if

ls_temp = upper(left(get_attribute("clear_report_queue"), 1))
if isnull(ls_temp) or ls_temp = "T" or ls_temp = "Y" then
	DELETE o_Report_Queue
	WHERE office_id = :gnv_app.office_id
	USING cprdb;
	if not cprdb.check() then return -1
end if

return 1

end function

private function str_attributes get_report_queue_attributes (long pl_report_key);integer li_attribute_sequence
string ls_attribute
string ls_value
boolean lb_loop
integer i
str_attributes lstr_attributes


DECLARE lc_report_queue_attribute CURSOR FOR  
  SELECT attribute_sequence,
  			attribute,
			value
    FROM o_report_queue_attribute
   WHERE report_key = :pl_report_key   ;


OPEN lc_report_queue_attribute;
if not tf_check() then return lstr_attributes

i = 0
lb_loop = true

DO
	FETCH lc_report_queue_attribute INTO
    		:li_attribute_sequence,
  			:ls_attribute,
			:ls_value;
	if not tf_check() then return lstr_attributes

	if sqlca.sqlcode = 0 then
		i++
		f_attribute_add_attribute(lstr_attributes, ls_attribute, ls_value)
	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_report_queue_attribute;

return lstr_attributes

end function

public function integer timer_ding ();long ll_report_key
string ls_report_id
datetime ldt_order_date_time
string ls_status
integer li_sts
integer li_report_count
long ll_row
str_attributes lstr_attributes
integer li_attribute_count
string ls_component_id
u_component_report luo_report

cprdb.begin_transaction(this, "do_reports()")
report_queue.dataobject = "dw_data_report_queue"
report_queue.settransobject(cprdb)
report_queue.retrieve(gnv_app.office_id)
cprdb.commit_transaction()

li_report_count = report_queue.rowcount()

for ll_row = 1 to li_report_count
	mylog.log(this, "u_component_reportserver.timer_ding:0022", "Processing #" + string(ll_row) + " of " + string(li_report_count), 1)
	ll_report_key = report_queue.object.report_key[ll_row]
	ls_report_id = report_queue.object.report_id[ll_row]
	ldt_order_date_time = report_queue.object.order_date_time[ll_row]

	SELECT component_id
	INTO :ls_component_id
	FROM c_Report_Definition
	WHERE report_id = :ls_report_id
	USING cprdb;
	if not cprdb.check() then return -1
	if cprdb.sqlcode = 100 then
		mylog.log(this, "u_component_reportserver.timer_ding:0034", "Invalid Report ID (" + ls_report_id + ")", 4)
		ls_status = "ERROR"
	end if
	
	lstr_attributes = get_report_queue_attributes(ll_report_key)

	if li_attribute_count < 0 then
		mylog.log(this, "u_component_reportserver.timer_ding:0041", "Unable to get report attributes (" + ls_report_id + ")", 4)
		ls_status = "ERROR"
	end if
			
	if ls_status <> "ERROR" then
		mylog.log(this, "u_component_reportserver.timer_ding:0046", "Started report - " + ls_report_id, 1)

		luo_report = my_component_manager.get_component(ls_component_id)
		if isnull(luo_report) then
			mylog.log(this, "u_component_reportserver.timer_ding:0050", "Unable to get report component (" + ls_component_id + ")", 4)
			ls_status = "ERROR"
		else
			li_sts = luo_report.printreport(ls_report_id, lstr_attributes)
			if li_sts <= 0 then
				ls_status = "ERROR"
			else
				ls_status = "OK"
			end if
		end if
	end if

	cprdb.begin_transaction(this, "do_reports()")

	// Set the status before deleting so the status will get copied to the log
	UPDATE o_report_queue
	SET report_status = :ls_status
	WHERE report_key = :ll_report_key
	USING cprdb;
	if not cprdb.check() then mark_error(ll_report_key)

	DELETE FROM o_report_queue
	WHERE report_key = :ll_report_key
	USING cprdb;
	if not cprdb.check() then mark_error(ll_report_key)

	cprdb.commit_transaction()

	mylog.log(this, "u_component_reportserver.timer_ding:0078", "Report finished, status = " + ls_status, 1)

next

return li_report_count

end function

on u_component_reportserver.create
call super::create
end on

on u_component_reportserver.destroy
call super::destroy
end on

event constructor;report_queue = CREATE datastore

end event

