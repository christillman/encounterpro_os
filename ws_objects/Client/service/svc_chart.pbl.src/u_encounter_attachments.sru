$PBExportHeader$u_encounter_attachments.sru
forward
global type u_encounter_attachments from u_attachments
end type
end forward

global type u_encounter_attachments from u_attachments
integer width = 2834
integer height = 1044
end type
global u_encounter_attachments u_encounter_attachments

on u_encounter_attachments.create
call super::create
end on

on u_encounter_attachments.destroy
call super::destroy
end on

type pb_new_attachments from u_attachments`pb_new_attachments within u_encounter_attachments
end type

type st_page from u_attachments`st_page within u_encounter_attachments
integer x = 2528
integer y = 608
end type

type pb_down from u_attachments`pb_down within u_encounter_attachments
end type

type pb_up from u_attachments`pb_up within u_encounter_attachments
end type

type dw_attachments from u_attachments`dw_attachments within u_encounter_attachments
integer x = 14
integer y = 16
integer height = 996
end type

