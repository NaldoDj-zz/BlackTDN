#include "totvs.ch"
CLASS utThread from tBigNThread
    METHOD New(oProcess) CONSTRUCTOR
END CLASS

user function tThread(oProcess)
return(utThread():New(oProcess))

Method New(oProcess) Class utThread
    _Super:New(oProcess)
Return(self)
