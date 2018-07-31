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

global type upgradescript from application
string appname = "upgradescript"
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

sp = CREATE script_producer
sp.go()



end event

