#ifdef SPANISH
	#define STR0001 "Cuadro de Horario"
	#define STR0002 "Se imprimira de acuerdo con los parametros solicitados por el"
	#define STR0003 "usuario."
	#define STR0004 "A Rayas"
	#define STR0005 "Administracion"
	#define STR0006 " de Trabajo"
	#define STR0007 "Sucursal: "
	#define STR0008 " - CGC: "
	#define STR0009 " - End.: "
	#define STR0010 "Fecha      |Dia      |1ª. Entrada| 1ª. Salida|2ª. Entrada| 2ª. Salida|3ª. Entrada| 3ª. Salida|4ª. Entrada| 4ª. Salida| Tipo del Dia | Tipo H.E. Normal |Tipo H.E. Nocturna|Excepc.|Turno|Seq.|Hrs.Trab.|Hrs.Int.|Cod.Comida."
	#define STR0011 "Trabajado"
	#define STR0012 "No Trabajado"
	#define STR0013 "D.S.R."
	#define STR0014 "Compensado"
	#define STR0015 "Feriado"
	#define STR0016 "Mat."
	#define STR0017 "Periodo de Apunte: "
	#define STR0018 "Calend&aacute;rio de Marca&ccedil;&otilde;es"
	#define STR0019 "Turno/Sec.: "
	#define STR0020 "Per&iacute;odo de Apunte: "
	#define STR0021 "Fecha"
	#define STR0022 "Dia"
	#define STR0023 "1&#170; Ent."
	#define STR0024 "1&#170; Sal."
	#define STR0025 "2&#170; Ent."
	#define STR0026 "2&#170; Sal."
	#define STR0027 "3&#170; Ent."
	#define STR0028 "3&#170; Sal."
	#define STR0029 "4&#170; Ent."
	#define STR0030 "4&#170; Sal."
	#define STR0031 "Tipo de Dia"
	#define STR0032 "Tipo H.E. Normal"
	#define STR0033 "Tipo H.E. Nocturna"
	#define STR0034 "Exce&ccedil;&atilde;o"
	#define STR0035 "Turno"
	#define STR0036 "Sec."
	#define STR0037 "Hrs.Trab."
	#define STR0038 "Hrs.Int."
	#define STR0039 "Cod.Comida"
	#define STR0040 "Nombre"
	#define STR0041 "Admision"
	#define STR0042 "Cargo/Descripcion"
	#define STR0043 "Centro de Costo/Descripcion"
	#define STR0044 "Categoria"
	#define STR0045 "Situacion"
	#define STR0046 "Turno Actual/Descripcion"
	#define STR0047 "Sec.Actual"
	#define STR0048 "Por Periodo"
	#define STR0049 "Por Fechas"
	#define STR0050 "Seleccione la opcion de impresion: "
	#define STR0051 "Depto./Descripcion"
#else
	#ifdef ENGLISH
		#define STR0001 "Schedule Chart"
		#define STR0002 "It will be printed according to the parameters selected by the"
		#define STR0003 "user."
		#define STR0004 "Z.Form"
		#define STR0005 "Management"
		#define STR0006 " for Work"
		#define STR0007 "Branch: "
		#define STR0008 " - CGC: "
		#define STR0009 " - Loc.: "
		#define STR0010 "Date       |Day      |1st. Inflow|1st.Outflow|2nd. Inflow|2nd.Outflow|3rd. Inflow|3rd.Outflow|4th. Inflow|4th.Outflow|  Type of Day | Type H.E. Normal |Tipo H.E. Night Sf|Except.|Shift|Seq.|Hrs.Wrkd.|Hrs.Int.|Meal Code  "
		#define STR0011 "Worked"
		#define STR0012 "Not Worked"
		#define STR0013 "D.S.R."
		#define STR0014 "Compensated"
		#define STR0015 "Holiday"
		#define STR0016 "Mat."
		#define STR0017 "Annotation Period: "
		#define STR0018 "Marks Calendar"
		#define STR0019 "Shift/Seq.: "
		#define STR0020 "Annotation Period: "
		#define STR0021 "Date"
		#define STR0022 "Day"
		#define STR0023 "1st Infl."
		#define STR0024 "1st Outfl."
		#define STR0025 "2nd Infl."
		#define STR0026 "2nd Outfl."
		#define STR0027 "3rd Infl."
		#define STR0028 "3rd Outfl."
		#define STR0029 "4th Infl."
		#define STR0030 "4th Outfl."
		#define STR0031 "Day Type"
		#define STR0032 "Type I.T. Normal"
		#define STR0033 "Type I.T. Nocturnal"
		#define STR0034 "Exception"
		#define STR0035 "Shift"
		#define STR0036 "Seq."
		#define STR0037 "Work Hrs."
		#define STR0038 "Int.Hrs."
		#define STR0039 "Meal Code"
		#define STR0040 "Name"
		#define STR0041 "Admission"
		#define STR0042 "Position/Description"
		#define STR0043 "Cost Center/Description"
		#define STR0044 "Category"
		#define STR0045 "Status"
		#define STR0046 "Current Shift/Description"
		#define STR0047 "Curr.Seq."
		#define STR0048 "By Period"
		#define STR0049 "By Dates"
		#define STR0050 "Select the printing option: "
		#define STR0051 "Department/Description"
	#else
		#define STR0001 If( cPaisLoc $ "ANG|PTG", "Quadro de horário", "Quadro de Horário" )
		#define STR0002 If( cPaisLoc $ "ANG|PTG", "Será impresso de acordo com os parâmetros solicitados pelo", "Será impresso de acordo com os parametros solicitados pelo" )
		#define STR0003 If( cPaisLoc $ "ANG|PTG", "Utilizador.", "usuário." )
		#define STR0004 If( cPaisLoc $ "ANG|PTG", "Código de barras", "Zebrado" )
		#define STR0005 If( cPaisLoc $ "ANG|PTG", "Administração", "Administraçäo" )
		#define STR0006 " de Trabalho"
		#define STR0007 "Filial: "
		#define STR0008 If( cPaisLoc $ "ANG|PTG", " - NIF: ", " - CGC: " )
		#define STR0009 If( cPaisLoc $ "ANG|PTG", " - Mor.: ", " - End.: " )
		#define STR0010 If( cPaisLoc $ "ANG|PTG", "Data       |Dia      |1a. Entrada| 1a. Saida |2a. Entrada| 2a. Saida |3a. Entrada| 3a. Saida |4a. Entrada| 4a. Saida |  Tipo do Dia | Tipo H.E. Normal |Tipo H.E. Noturna |Exceção|Turno|Seq.|Hrs.Trab.|Hrs.Int.|Cod.Refeic.", "Data       |Dia      |1a. Entrada| 1a. Saida |2a. Entrada| 2a. Saida |3a. Entrada| 3a. Saida |4a. Entrada| 4a. Saida |  Tipo do Dia | Tipo H.E. Normal |Tipo H.E. Noturna |Excecao|Turno|Seq.|Hrs.Trab.|Hrs.Int.|Cod.Refeic." )
		#define STR0011 "Trabalhado"
		#define STR0012 If( cPaisLoc $ "ANG|PTG", "Não Trabalhado", "Nao Trabalhado" )
		#define STR0013 "D.S.R."
		#define STR0014 "Compensado"
		#define STR0015 "Feriado"
		#define STR0016 If( cPaisLoc $ "ANG|PTG", "Reg.", "Mat." )
		#define STR0017 If( cPaisLoc $ "ANG|PTG", "Período de registo", "Periodo de Apontamento: " )
		#define STR0018 If( cPaisLoc $ "ANG|PTG", "Calend&aacute;rio De Marca&ccedil;&otilde;es", "Calend&aacute;rio de Marca&ccedil;&otilde;es" )
		#define STR0019 If( cPaisLoc $ "ANG|PTG", "Turno/Seq.:", "Turno/Seq.: " )
		#define STR0020 If( cPaisLoc $ "ANG|PTG", "Per&í&odo de registo", "Per&iacute;odo de Apontamento: " )
		#define STR0021 "Data"
		#define STR0022 "Dia"
		#define STR0023 "1&#170; Ent."
		#define STR0024 "1&#170; Sai."
		#define STR0025 "2&#170; Ent."
		#define STR0026 "2&#170; Sai."
		#define STR0027 "3&#170; Ent."
		#define STR0028 "3&#170; Sai."
		#define STR0029 "4&#170; Ent."
		#define STR0030 "4&#170; Sai."
		#define STR0031 If( cPaisLoc $ "ANG|PTG", "Tipo De Dia", "Tipo do Dia" )
		#define STR0032 If( cPaisLoc $ "ANG|PTG", "Tipo Hr. Ext. Normal", "Tipo H.E. Normal" )
		#define STR0033 If( cPaisLoc $ "ANG|PTG", "Tipo Hr. Ext. Nocturna", "Tipo H.E. Noturna" )
		#define STR0034 If( cPaisLoc $ "ANG|PTG", "Exce&pç&ão", "Exce&ccedil;&atilde;o" )
		#define STR0035 "Turno"
		#define STR0036 "Seq."
		#define STR0037 If( cPaisLoc $ "ANG|PTG", "Hrs. trab.", "Hrs.Trab." )
		#define STR0038 If( cPaisLoc $ "ANG|PTG", "Hrs. interv.", "Hrs.Int." )
		#define STR0039 If( cPaisLoc $ "ANG|PTG", "Cód. refeição", "Cod.Refeic." )
		#define STR0040 "Nome"
		#define STR0041 If( cPaisLoc $ "ANG|PTG", "Admissão", "Admissao" )
		#define STR0042 If( cPaisLoc $ "ANG|PTG", "Categoria/descrição", "Cargo/Descricao" )
		#define STR0043 If( cPaisLoc $ "ANG|PTG", "Centro De Custo/descrição", "Centro de Custo/Descricao" )
		#define STR0044 "Categoria"
		#define STR0045 If( cPaisLoc $ "ANG|PTG", "Situação", "Situacao" )
		#define STR0046 If( cPaisLoc $ "ANG|PTG", "Turno Actual/descrição", "Turno Atual/Descricao" )
		#define STR0047 If( cPaisLoc $ "ANG|PTG", "Seq.actual", "Seq.Atual" )
		#define STR0048 "Por Período"
		#define STR0049 "Por Datas"
		#define STR0050 If( cPaisLoc $ "ANG|PTG", "Seleccionar a opção  de impressao: ", "Selecione a opção de impressão: " )
		#define STR0051 If( cPaisLoc $ "ANG|PTG", "Departamento/descrição ", "Departamento/Descrição" )
	#endif
#endif
