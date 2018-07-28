$PBExportHeader$u_results_by_treatment_atchments.sru
forward
global type u_results_by_treatment_atchments from u_attachments
end type
end forward

global type u_results_by_treatment_atchments from u_attachments
integer width = 2245
integer height = 1356
end type
global u_results_by_treatment_atchments u_results_by_treatment_atchments

on u_results_by_treatment_atchments.create
call super::create
end on

on u_results_by_treatment_atchments.destroy
call super::destroy
end on

type pb_new_attachments from u_attachments`pb_new_attachments within u_results_by_treatment_atchments
integer x = 1966
integer y = 40
end type

type st_page from u_attachments`st_page within u_results_by_treatment_atchments
integer x = 1582
integer y = 328
integer width = 123
integer height = 104
integer textsize = -7
integer weight = 700
long backcolor = 12632256
end type

type pb_down from u_attachments`pb_down within u_results_by_treatment_atchments
integer x = 1568
integer y = 200
end type

type pb_up from u_attachments`pb_up within u_results_by_treatment_atchments
integer x = 1573
integer y = 60
end type

type dw_attachments from u_attachments`dw_attachments within u_results_by_treatment_atchments
integer x = 0
integer y = 4
integer width = 1929
integer height = 1352
end type

