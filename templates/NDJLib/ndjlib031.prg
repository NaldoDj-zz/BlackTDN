#include "totvs.ch"
CLASS utThread from tBigNThread
    METHOD New() CONSTRUCTOR
END CLASS

user function tThread()
return(utThread():New())

Method New() Class utThread
    _Super:New()
Return(self)
