$PBExportHeader$upgradescript.sra
$PBExportComments$Generated Application Object
forward
global type upgradescript from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables

end variables

global type upgradescript from application
string appname = "upgradescript"
string appruntimeversion = "19.2.0.2670"
end type
global upgradescript upgradescript

type prototypes

end prototypes

on upgradescript.create
appname="upgradescript"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on upgradescript.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
script_producer sp
line_number_updater lnu

//lnu = CREATE line_number_updater
//lnu.update_line_numbers()

sp = CREATE script_producer
sp.go()



end event

