$PBExportHeader$u_windows_api.sru
forward
global type u_windows_api from nonvisualobject
end type
end forward

global type u_windows_api from nonvisualobject
end type
global u_windows_api u_windows_api

type variables
n_cst_kernel32 kernel32
n_cst_shell32 shell32
n_cst_advapi32 advapi32
n_cst_gdi32 gdi32
n_cst_user32 user32
n_cst_comdlg32 comdlg32
n_versioninfo versioninfo


end variables

on u_windows_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_windows_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

