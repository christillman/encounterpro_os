$PBExportHeader$epiegateway_credentialsheader.sru
$PBExportComments$Proxy imported from Web service using Web Service Proxy Generator.
forward
    global type epiegateway_CredentialsHeader from nonvisualobject
    end type
end forward

global type epiegateway_CredentialsHeader from nonvisualobject
end type

type variables
    string User
    string Password
    any AnyAttr[]
    string EncodedMustUnderstand
    string EncodedMustUnderstand12
    boolean MustUnderstand
    string Actor
    string Role
    boolean DidUnderstand
    string EncodedRelay
    boolean Relay
end variables

on epiegateway_CredentialsHeader.create
call super::create
TriggerEvent( this, "constructor" )
end on

on epiegateway_CredentialsHeader.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

