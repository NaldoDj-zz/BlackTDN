#include "totvs.ch"
CLASS utThread from tHash
    
    data cClassName
    
    METHOD New() CONSTRUCTOR
    Method ClassName()
    
    Method ParamSet(cParameter,uValue)
    Method ParamGet(cParameter,uDValue)
    
    Method Start()
    Method Notify()
    Method Wait()
    Method Join()
    
END CLASS

Method New() Class utThread
    _Super:New()
    self:ClassName()
Return(self)

Method ClassName()  Class utThread
    self:cClassName:=(_Super:ClassName()+"_"+GetClassName(self))
Return(self:cClassName)

Method ParamSet(cParameter,uValue) Class utThread
    self:Set(cParameter,uValue)
Return(self)

Method ParamGet(cParameter,uDValue) Class utThread
Return(self:Get(cParameter,uDValue))

Method Start() Class utThread
Return(self)

Method Notify() Class utThread
Return(self)

Method Wait() Class utThread
Return(self)

Method Join() Class utThread
Return(self)
