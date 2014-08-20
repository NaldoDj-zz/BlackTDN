// ######################################################################################
// Projeto: DATA WAREHOUSE
// Modulo : Ferramentas
// Fonte  : DWDefs - Definições de uso genérico
// ---------+-------------------+--------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+--------------------------------------------------------
// 20.06.01 | 0548-Alan Candido |
// --------------------------------------------------------------------------------------

#ifndef _DWDEFS_CH
#define _DWDEFS_CH

#translate isNull(<var>);
	=> (valType(<var>)=="U")

#translate isNull(<var>, <value>);
	=> (iif(isNull(<var>), <value>, DWConvTo(valType(<value>), <var>) ))

#translate isEmpty(<var>, <value>);
	=> (iif(empty(<var>), <value>, DWConvTo(valType(<value>), <var>) ))

#xcommand default <var> := <value>;
	=> <var> := iif(valType(<var>)=="U", <value>, <var>);

#xcommand property <propname> := <value>;
	=> <propname> := iif(valType(<value>)=="U", <propname>, <value>)

#xcommand default <var> := <value> notdef <value1>;
	=> <var> := iif(valType(<var>)=="U", <value>, <value1>);

/*
#translate getProp-><name>;
    => DWGetProp(<"name">, procname(0))

#xcommand setProp-><name> := <exp>;
    => DWSetProp(<"name">, <exp>, procname(0))

#translate getProp-><procName>-><name>;
    => DWGetProp(<"name">, <procName>)

#xcommand setProp-><procName>-><name> := <exp>;
    => DWSetProp(<"name">, <exp>, <procName>)
*/

#translate getProp-><name> => 

#xcommand setProp-><name> := <exp> => ?????????

#translate DWGetProp(<name>);
	 => DWGetProp(<name>, procname(0))

#translate DWSetProp(<name>);
	 => DWSetProp(<name>, procname(0))

#endif
