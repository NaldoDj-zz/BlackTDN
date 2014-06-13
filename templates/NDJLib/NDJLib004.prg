#INCLUDE "NDJ.CH"

Static __aPublicV	:= {}
Static __nPublicV	:= 0

#IFNDEF __IUSEMDJLIB

	/*/
		Funcao:		U_SIGAATF
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAATF
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAATF()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAATF/*/
			StaticCall( U_SIGAATF , SIGAATF )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACOM
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACOM
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACOM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
		
			/*/Executa Tratamento Especifico para o Modulo SIGACOM/*/
			StaticCall( U_SIGACOM , SIGACOM )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACON
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACON
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACON()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACON/*/
			StaticCall( U_SIGACON , SIGACON )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEST()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEST/*/
			StaticCall( U_SIGAEST , SIGAEST )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAFAT
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAFAT
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAFAT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAFAT/*/
			StaticCall( U_SIGAFAT , SIGAFAT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAFIN
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAFIN
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAFIN()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
		
			/*/Executa Tratamento Especifico para o Modulo SIGAFIN/*/
			StaticCall( U_SIGAFIN , SIGAFIN )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGPE
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGPE
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGPE()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGPE/*/
			StaticCall( U_SIGAGPE , SIGAGPE )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAFAS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAFAS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAFAS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAFAS/*/
			StaticCall( U_SIGAFAS , SIGAFAS )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAFIS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAFIS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAFIS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
		
			/*/Executa Tratamento Especifico para o Modulo SIGAFIS/*/
			StaticCall( U_SIGAFIS , SIGAFIS )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPCP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPCP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPCP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPCP/*/
			StaticCall( U_SIGAPCP , SIGAPCP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAVEI
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAVEI
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAVEI()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAVEI/*/
			StaticCall( U_SIGAVEI , SIGAVEI )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGALOJA
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGALOJA
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGALOJA()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGALOJA/*/
			StaticCall( U_SIGALOJA , SIGALOJA )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGATMK
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGATMK
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGATMK()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATMK/*/
			StaticCall( U_SIGATMK , SIGATMK )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAOFI
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAOFI
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAOFI()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAOFI/*/
			StaticCall( U_SIGAOFI , SIGAOFI )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGARPM
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGARPM
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGARPM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGARPM/*/
			StaticCall( U_SIGARPM , SIGARPM )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPON
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPON
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPON()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
		
			/*/Executa Tratamento Especifico para o Modulo SIGAPON/*/
			StaticCall( U_SIGAPON , SIGAPON )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEIC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEIC/*/
			StaticCall( U_SIGAEIC , SIGAEIC )
		
		End Sequence
		
	Return( NIL )

	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGATCF()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATCF/*/
			StaticCall( U_SIGATCF , SIGATCF )
		
		End Sequence
		
	Return( NIL )

	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAMNT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAMNT/*/
			StaticCall( U_SIGAMNT , SIGAMNT )
		
		End Sequence
		
	Return( NIL )

	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGARSP()

		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGARSP/*/
			StaticCall( U_SIGARSP , SIGARSP )
		
		End Sequence

	Return( NIL )

	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQIE()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQIE/*/
			StaticCall( U_SIGAQIE , SIGAQIE )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQMT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQMT/*/
			StaticCall( U_SIGAQMT , SIGAQMT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAFRT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAFRT/*/
			StaticCall( U_SIGAFRT , SIGAFRT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQDO()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQDO/*/
			StaticCall( U_SIGAQDO , SIGAQDO )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQIP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQIP/*/
			StaticCall( U_SIGAQIP , SIGAQIP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGATRM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATRM/*/
			StaticCall( U_SIGATRM , SIGATRM )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEIF()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEIF/*/
			StaticCall( U_SIGAEIF , SIGAEIF )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGATEC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATEC/*/
			StaticCall( U_SIGATEC , SIGATEC )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEEC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEEC/*/
			StaticCall( U_SIGAEEC , SIGAEEC )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEFF()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEFF/*/
			StaticCall( U_SIGAEFF , SIGAEFF )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAECO()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAECO/*/
			StaticCall( U_SIGAECO , SIGAECO )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEST
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAAFV()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAAFV/*/
			StaticCall( U_SIGAAFV , SIGAAFV )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPLS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEST
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPLS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPLS/*/
			StaticCall( U_SIGAPLS , SIGAPLS )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACTB
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACTB
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACTB()
	
		Begin Sequence
	
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACTB/*/
			StaticCall( U_SIGACTB , SIGACTB )
	
		End Sequence
	
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAMDT
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAMDT
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAMDT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAMDT/*/
			StaticCall( U_SIGAMDT , SIGAMDT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAQNC
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAQNC
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQNC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQNC/*/
			StaticCall( U_SIGAQNC , SIGAQNC )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAQAD
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAQAD
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQAD()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQAD/*/
			StaticCall( U_SIGAQAD , SIGAQAD )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAQCP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAQCP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAQCP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAQCP/*/
			StaticCall( U_SIGAQCP , SIGAQCP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAOMS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAOMS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAOMS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAOMS/*/
			StaticCall( U_SIGAOMS , SIGAOMS )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACSA
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACSA
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACSA()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACSA/*/
			StaticCall( U_SIGACSA , SIGACSA )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPEC
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPEC
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPEC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPEC/*/
			StaticCall( U_SIGAPEC , SIGAPEC )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAWMS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAWMS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAWMS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAWMS/*/
			StaticCall( U_SIGAWMS , SIGAWMS )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGATMS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGATMS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGATMS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATMS/*/
			StaticCall( U_SIGATMS , SIGATMS )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPMS
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPMS
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPMS()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGATMS/*/
			StaticCall( U_SIGAPMS , SIGAPMS )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACDA
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACDA
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACDA()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACDA/*/
			StaticCall( U_SIGACDA , SIGACDA )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAACD
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAACD
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAACD()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAACD/*/
			StaticCall( U_SIGAACD , SIGAACD )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPPAP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPPAP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPPAP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPPAP/*/
			StaticCall( U_SIGAPPAP , SIGAPPAP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAREP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAREP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAREP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAREP/*/
			StaticCall( U_SIGAREP , SIGAREP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGE
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGE
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGE()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGE/*/
			StaticCall( U_SIGAGE , SIGAGE )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAEDC
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAEDC
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAEDC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAEDC/*/
			StaticCall( U_SIGAEDC , SIGAEDC )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAHSP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAHSP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAHSP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAHSP/*/
			StaticCall( U_SIGAHSP , SIGAHSP )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAVDOC
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAVDOC
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAVDOC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAVDOC/*/
			StaticCall( U_SIGAVDOC , SIGAVDOC )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAAPD
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAAPD
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAAPD()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAAPD/*/
			StaticCall( U_SIGAAPD , SIGAAPD )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGSP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGSP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGSP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGSP/*/
			StaticCall( U_SIGAGSP , SIGAGSP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACRD
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACRD
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACRD()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACRD/*/
			StaticCall( U_SIGACRD , SIGACRD )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGASGA
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGASGA
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGASGA()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGASGA/*/
			StaticCall( U_SIGASGA , SIGASGA )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPCO
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPCO
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPCO()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPCO/*/
			StaticCall( U_SIGAPCO , SIGAPCO )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGPR
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGPR
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGPR()
	
		Begin Sequence
			
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGPR/*/
			StaticCall( U_SIGAGPR , SIGAGPR )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGAC
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGAC
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGAC()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGAC/*/
			StaticCall( U_SIGAGAC , SIGAGAC )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAHEO
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAHEO
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAHEO()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAHEO/*/
			StaticCall( U_SIGAHEO , SIGAHEO )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAHGP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAHGP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAHGP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAHGP/*/
			StaticCall( U_SIGAHGP , SIGAHGP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAHHG
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAHHG
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAHHG()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAHHG/*/
			StaticCall( U_SIGAHHG , SIGAHHG )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAHPL
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAHPL
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAHPL()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAHPL/*/
			StaticCall( U_SIGAHPL , SIGAHPL )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAAPT
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAAPT
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAAPT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAAPT/*/
			StaticCall( U_SIGAAPT , SIGAAPT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGAV
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGAV
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGAV()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGAV/*/
			StaticCall( U_SIGAGAV , SIGAGAV )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAICE
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAICE
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAICE()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAICE/*/
			StaticCall( U_SIGAICE , SIGAICE )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAAGR
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAAGR
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAAGR()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAAGR/*/
			StaticCall( U_SIGAAGR , SIGAAGR )
	
		End Sequence
	
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAARM
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAARM
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAARM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAARM/*/
			StaticCall( U_SIGAARM , SIGAARM )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAGCT
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAGCT
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAGCT()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAGCT/*/
			StaticCall( U_SIGAGCT , SIGAGCT )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAORG
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAORG
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAORG()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAORG/*/
			StaticCall( U_SIGAORG , SIGAORG )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGALVE
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGALVE
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGALVE()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGALVE/*/
			StaticCall( U_SIGALVE , SIGALVE )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAPHOTO
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAPHOTO
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAPHOTO()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAPHOTO/*/
			StaticCall( U_SIGAPHOTO , SIGAPHOTO )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGACRM
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACRM
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACRM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGACRM/*/
			StaticCall( U_SIGACRM , SIGACRM )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGABPM
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGABPM
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGABPM()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGABPM/*/
			StaticCall( U_SIGABPM , SIGABPM )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_SIGAESP
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAESP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAESP()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAESP/*/
			StaticCall( U_SIGAESP , SIGAESP )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_EspNome
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Retorna a Descricao para o Modulo SIGAESP
		Sintaxe:	<vide parametros formais>
	/*/
	User Function EspNome()
	
		Local aRetMod
		
		Local bError			:= { || aRetMod := &(cError) }
		Local nESP 				:= 0
		
		Local cError			:= "aRetModName"
	
		TRYEXCEPTION USING bError
			ValGroup("")
		ENDEXCEPTION	
	
		IF ( ValType( aRetMod ) == "A" )
			nESP := aScan( aRetMod , { |aModName| ( aModName[2] == "SIGAESP" ) } )
			IF ( nESP > 0 )
				//Substitua o Recurso "LVEIMG" pelo Recurso Definido para esse modulo
				//Ex.: aRetMod[nESP][05]	:= "ESPIMG"
				aRetMod[nESP][05]	:= "LVEIMG"
			EndIF
		EndIF	
	
	Return( ProcName() ) //Informe a Descricao Real no lugar de ProcName()
	
	/*/
		Funcao:		U_SIGAESP1
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAESP1
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAESP1()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAESP1/*/
			StaticCall( U_SIGAESP1 , SIGAESP1 )
	
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_Esp1Nome
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Retorna a Descricao para o Modulo SIGAESP1
		Sintaxe:	<vide parametros formais>
	/*/
	User Function Esp1Nome()
	
		Local aRetMod
		
		Local bError			:= { || aRetMod := &(cError) }
		Local nESP 				:= 0
		
		Local cError			:= "aRetModName"
		
		TRYEXCEPTION USING bError
			ValGroup("")
		ENDEXCEPTION	
	
		IF ( ValType( aRetMod ) == "A" )
			nESP := aScan( aRetMod , { |aModName| ( aModName[2] == "SIGAESP1" ) } )
			IF ( nESP > 0 )
				//Substitua o Recurso "LVEIMG" pelo Recurso Definido para esse modulo
				//Ex.: aRetMod[nESP][05]	:= "ESP1IMG"
				aRetMod[nESP][05]	:= "LVEIMG"
			EndIF
		EndIF	
	
	Return( ProcName() )//Informe a Descricao Real no lugar de ProcName()
	
	/*/
		Funcao:		U_SIGAESP2
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGAESP2
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGAESP2()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
	
			/*/Executa Tratamento Especifico para o Modulo SIGAESP2/*/
			StaticCall( U_SIGAESP2 , SIGAESP2 )
		
		End Sequence
		
	Return( NIL )
	
	/*/
		Funcao:		U_Esp2Nome
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Retorna a Descricao para o Modulo SIGAESP2
		Sintaxe:	<vide parametros formais>
	/*/
	User Function Esp2Nome()
	
		Local aRetMod
		
		Local bError			:= { || aRetMod := &(cError) }
		Local nESP 				:= 0
		
		Local cError			:= "aRetModName"
		
		TRYEXCEPTION USING bError
			ValGroup("")
		ENDEXCEPTION	
	
		IF ( ValType( aRetMod ) == "A" )
			nESP := aScan( aRetMod , { |aModName| ( aModName[2] == "SIGAESP2" ) } )
			IF ( nESP > 0 )
				//Substitua o Recurso "LVEIMG" pelo Recurso Definido para esse modulo
				//Ex.: aRetMod[nESP][05]	:= "ESP2IMG"
				aRetMod[nESP][05]	:= "LVEIMG"
			EndIF
		EndIF	
	
	Return( ProcName() ) //Informe a Descricao Real no lugar de ProcName()
	
	/*/
		Funcao:		U_SIGACFG
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao Generica do Modulo SIGACFG
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SIGACFG()
	
		Begin Sequence
		
			/*/Carrega as Funcoes especificas para Inicializacao do sistema/*/
			InitSystem()
		
			/*/Executa Tratamento Especifico para o Modulo SIGACFG/*/
			StaticCall( U_SIGACFG , SIGACFG )
		
		End Sequence
	
	Return( NIL )
	
	/*/
		Funcao:		U_MODNAME
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Ponto de Entrada da RetModname
		Sintaxe:	<vide parametros formais>
	/*/
	User Function MODNAME( aRetModName )
	Return( aRetModName )
	
	/*/
		Funcao:		SDULogin
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Validar o Acesso ao SDU
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SDULogin()
	
		Local cUserName		:= ParamIxb
		
		Local lSDULogin		:= .T.
	
		IF .NOT.( Empty( cUserName ) )
			//...Testa o usuario
		EndIF
	
	Return( lSDULogin )
	
	/*/
		Funcao:		SDULogout
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Validar o Acesso ao SDU
		Sintaxe:	<vide parametros formais>
	/*/
	User Function SDULogout()
	
		Local cUserName		:= ParamIxb[1]
		Local lSDULogOut	:= .T.
		
		IF .NOT.( Empty( cUserName ) )
			//...Testa o usuario
		EndIF
	
	Return( lSDULogOut )
	
	/*/
		Funcao:		MdiOk
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Funcao de Validacao do Acesso MDI
		Sintaxe:	<vide parametros formais>
	/*/
	User Function MdiOk()
	
		Local lMdiOk			:= MdiGetAccess()
	
	Return( lMdiOk )
	
	/*/
		Funcao:		ChgPrDir
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Ponto de entrada  CHGPRDIR executado em SenhaOk() para  alterar o Diretorio de Impressao
		Sintaxe:	<vide parametros formais>
	/*/
	User Function ChgPrDir()
	Return(StaticCall(U_ChgPrDir,ChgPrDir)) //Tratamento para o PE ChgPrDir
	
	/*/
		Funcao:		PswValid
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Ponto de entrada PSWVALID
		Sintaxe:	<vide parametros formais>
	/*/
*	User Function PswValid()
*	Return( .T. )

	/*/
		Funcao:		PswSize
		Autor:		Marinaldo de Jesus 
		Data:		17/01/2010
		Descricao:	Ponto de entrada PSWSIZE
		Sintaxe:	<vide parametros formais>
	/*/
*	User Function PswSize()
*	Return(StaticCall(U_PswSize,PswSize))

	/*/
		Funcao:		CallChgXNU
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Ponto de Entrada Antes da Carga do Menu do SIGA 
		Sintaxe:	<vide parametros formais>
	/*/
	User Function CallChgXNU()
		
		Local cArqMnu		:= ParamIXB[5]
		
		Begin Sequence
		
			/*/
				ParamIXB:
				[1] - ID do Usuario
				[2] - Codigo da Empresa
				[3] - Filial da Empresa
				[4] - Codigo do Modulo
				[5] - Nome do Menu
			/*/
			
		End Sequence
		
	Return( cArqMnu )
	
	/*/
		Funcao:		ChkExec
		Autor:		Marinaldo de Jesus 
		Data:		25/12/2010
		Descricao:	Ponto de entrada chamado na funcao __Execute que eh utilizada para a execucao de todos os programas no menu de usuario
		Sintaxe:	<vide parametros formais>
	/*/
	User Function ChkExec()
	
		InitSystem()
	
	Return( .T. )

	/*/
		Funcao:		Final
		Autor:		Marinaldo de Jesus 
		Data:		12/07/2011
		Descricao:	Define funcao de Usuario a ser executada na Finalizacao do Sistema
		Sintaxe:	SetOnEXIT( "U_Final" , .F. )
		Obs.:		SetOnEXIT nao Funciona com MDI. Encapsular a chamada a SIGAMDI para ter o Controle e usar MDIOK
					para validar o acesso.
	/*/
	User Function Final( cStr1 , cStr2 , oError )

		DEFAULT cStr1	:= ""
		DEFAULT cStr2	:= ""
		DEFAULT oError	:= NIL

		/*/Libero Todos os Locks Pendentes/*/
        StaticCall( NDJLIB003 , AliasUnLock )

	Return( .T. )

#ENDIF //__IUSEMDJLIB

/*/
	Funcao:		InitSystem
	Autor:		Marinaldo de Jesus 
	Data:		25/12/2010
	Descricao:	Define a Inicializacao padrao customizada para Todos os Modulos do sistema
    Sintaxe:    StaticCall( NDJLIB004 , InitSystem )
/*/
Static Function InitSystem()

	Local oException

	TRYEXCEPTION

		/*/Redefine o Numero Maximo de Codigos em Uso/*/
		SetMaxCodes( 10000 )

		/*/Libero Todos os Locks Pendentes/*/
        StaticCall( NDJLIB003 , AliasUnLock )

		/*/Encerro os Arquivos de Trabalho/*/
        StaticCall( U_NDJBLKSCVL , EmpFrmClose )

        /*/Define as Variaveis Publicas a Serem utilizadas na NDJ/*/
        SetPublic( "__nSZ5LstRec"   , 0   	, "N" , 0 , .T. )
        SetPublic( "_C1XNumero"     , ""  	, "C" , 0 , .T. )
        SetPublic( "_C1XModali"     , ""  	, "C" , 0 , .T. )
        SetPublic( "__aNDJSC7Reg"   , NIL     , "A" , 0 , .T. )
		SetPublic( "__cSZ0TTSAlias" , ""	, "C" , 3 , .T. )
		SetPublic( "__cTrbAFBAlias" , "AFB"	, "C" , 3 , .T. )
		SetPublic( "__cTrbAJCAlias" , "AJC"	, "C" , 3 , .T. )
		SetPublic( "__cTrbSZ0Alias" , "SZ0"	, "C" , 3 , .T. )
		SetPublic( "__cTrbSD1Alias" , "SD1"	, "C" , 3 , .T. )
		SetPublic( "__lMT103CAN" 	, .F.	, "L" , 1 , .T. )

        /*/ReDefine as Variaveis Publicas a Serem utilizadas na NDJ/*/
		ReSetPublic()

		/*/Define funcao a ser executada na Finalizacao da Aplicacao/*/
		MySetOnEXIT()

		/*/Reinicializa as Statics em U_CN200SPC/*/
		StaticCall( U_CN200SPC , CN200SPCReset )

		/*/Limpa a Pilha de Valores de SF1 e SD1/*/
		StaticCall( U_MT140APV , SF1SD1Arr , .F. , .F. , .T. ) 

	CATCHEXCEPTION USING oException

		ConOut( CaptureError( .T. ) )

	ENDEXCEPTION

Return( NIL )

/*/
	Funcao:		MySetOnEXIT
	Autor:		Marinaldo de Jesus 
	Data:		12/07/2011
	Descricao:	Define funcao de Usuario a ser executada na Finalizacao do Sistema
    Sintaxe:    StaticCall( NDJLIB004 , MySetOnEXIT )
/*/
Static Function MySetOnEXIT()

	Local bErrorBlock
	Local bSysErrorBlock

	Local lSetErrorBlock
	
	Static __bAppWndVld
	Static __bErrorBlock
	Static __bSysErrorBlock
	
	IF ( ( Type("oApp" ) == "O" ) .and. oApp:lMDI )
		IF ( __bAppWndVld == NIL )
			__bAppWndVld			:= oApp:oMainWnd:bValid
			oApp:oMainWnd:bValid	:= { || U_Final() , Eval( __bAppWndVld) } 
		EndIF
	EndIF

	lSetErrorBlock	:= .NOT.( ValType( __bErrorBlock ) == "B" )
	IF ( lSetErrorBlock )

		bErrorBlock			:= ErrorBlock()
		__bErrorBlock		:= { |oError| Eval( @bErrorBlock , @oError ) , U_Final( NIL , NIL , @oError ) }
		ErrorBlock( __bErrorBlock )
		
		bSysErrorBlock		:= SysErrorBlock()
		__bSysErrorBlock	:= { |oError| Eval( @bSysErrorBlock , @oError ) , U_Final( NIL , NIL , @oError ) }
		SysErrorBlock( __bSysErrorBlock )

	EndIF

	SetOnEXIT( "U_Final" , .F. )

Return( .T. )

/*/
	Funcao:		MdiGetAccess
	Autor:		Marinaldo de Jesus 
	Data:		25/12/2010
	Descricao:	Verifica se Habilitara o Acesso ao SIGAMDI
    Sintaxe:    StaticCall( NDJLIB004 , MdiGetAccess )
/*/
Static Function MdiGetAccess()
	MySetOnEXIT()
Return( .T. )

/*/
    Funcao:     SetPublic
	Autor:		Marinaldo de Jesus 
	Data:		08/08/2011
    Descricao:  Define as Variaveis Publicas Utilizadas na NDJ
    Sintaxe:    StaticCall( NDJLIB004 , SetPublic , cPublic , uSet , cType , nSize , lRestart , lModule , cStack )
	
/*/
Static Function SetPublic( cPublic , uSet , cType , nSize , lRestart , lModule , cStack )
	DEFAULT lModule := .T.
	AddPublic( @cPublic , @uSet , @cType , @nSize , @lRestart , @lModule , @cStack )
Return( __aPublicV )

/*/
	Funcao:		ReSetPublic
	Autor:		Marinaldo de Jesus 
	Data:		08/08/2011
    Descricao:    ReDefine as Variaveis Publicas Utilizadas na NDJ
    Sintaxe:    StaticCall( NDJLIB004 , ReSetPublic , lModule , cStack )
	
/*/
Static Function ReSetPublic( lModule , cStack )

	Local aStack
	Local aModName

	Local bReset	:= { || AddPublic( @__aPublicV[nBL][1] , NIL , @__aPublicV[nBL][2] , @__aPublicV[nBL][3] , @.T. , @lModule , @cStack ) }

	Local nAT
	Local nBL
	Local nEL

	DEFAULT lModule	:= .T.
	IF ( lModule )
		aStack			:= GetCallStack()
		IF ( lModule )
			nEL 		:= Len( aStack )
			aModName	:= RetModName( .T. )
			For nBL := nEL To 1 STEP - 1
				nAT				:= aScan( aModName , { |aModName| ( ( "U_" + aModName[ 2 ] ) == aStack[ nBL ] ) } )
				IF ( nAT > 0 )
					EXIT
				EndIF
			Next nBL
			IF ( nAT > 0 )
				cStack	:= aStack[ nBL ]
			Else
				cStack	:= aStack[ nEL ]
			EndIF	
		Else
			cStack		:= aStack[ nEL ]
		EndIF
		nEL 			:= __nPublicV
		For nBL := 1 To nEL
			IF ( cStack == __aPublicV[ nBL ][ 4 ] )
				Eval( bReset )
			EndIF	
		Next nBL
	ElseIF .NOT.( cStack == NIL )
		nEL 			:= __nPublicV
		For nBL := 1 To nEL
			IF ( cStack == __aPublicV[ nBL ][ 4 ] )
				Eval( bReset )
			EndIF
		Next nBL
	Else
		nEL 			:= __nPublicV
		For nBL := 1 To nEL
			cStack	:= __aPublicV[ nBL ][ 4 ]
			Eval( bReset )
		Next nBL
	EndIF

Return( .T. )

/*/
	Funcao:		AddPublic
	Autor:		Marinaldo de Jesus 
	Data:		08/08/2011
	Descricao:	Adiciona as Variaveis Publicas
/*/
Static Function AddPublic( cPublic , uSet , cType , nSize , lRestart , lModule , cStack )

	Local aStack
	Local aModName

	Local cVar

	Local nAT
	Local nBL
	Local nEL

	DEFAULT cPublic		:= "__UndefPVar__"
	DEFAULT lRestart	:= .NOT.( ValType( uSet ) == "U" )
	DEFAULT lModule		:= .T.

	cVar				:= Upper( AllTrim( cPublic ) )
	nAT					:= aScan( __aPublicV , { |aPublic| aPublic[ 1 ] == cVar } )

	IF ( nAT == 0 )
		DEFAULT cType	:= ValType( uSet )
		DEFAULT nSize	:= 0
		IF ( cStack == NIL )
			aStack		:= GetCallStack()
			nEL 		:= Len( aStack )
			IF ( lModule )
				aModName	:= RetModName( .T. )
				For nBL := nEL To 1 STEP - 1
					nAT		:= aScan( aModName , { |aModName| ( aModName[ 2 ] == aStack[ nBL ] ) } )
					IF ( nAT > 0 )
						EXIT
					EndIF
				Next nBL
				IF ( nAT > 0 )
					cStack	:= aStack[ nBL ]
				Else
					cStack	:= aStack[ nEL ]
				EndIF	
			Else
				cStack		:= aStack[ nEL ]
			EndIF
		EndIF
		nAT			:= aScan( __aPublicV , { |aPublic| ( aPublic[ 1 ] == cVar ) .and. ( aPublic[ 4 ] == cStack ) } )
		IF ( nAT == 0 )
			aAdd( __aPublicV , { cVar , cType , nSize , cStack } )
			nAT			:= Len( __aPublicV )
			__nPublicV	:= nAT
			lRestart	:= .T.
		EndIF	
		DEFAULT uSet	:= GetValType( @cType , @nSize )
		IF .NOT.( Type( cVar ) == cType )
			_SetNamedPrvt( @cVar , @uSet , @cStack )
		ElseIF ( lRestart )
			IF ( cType == "A" )
				IF ( ( ValType( uSet ) == "A" ) .or. .NOT.( Type( cVar ) == "A" ) )
					_SetNamedPrvt( @cVar , aClone( uSet ) , @cStack )
				Else
					aSize( &cVar , @nSize )
				EndIF
			Else
				_SetNamedPrvt( @cVar , @uSet , @cStack )
			EndIF	
		EndIF	
	ElseIF ( lRestart )
		IF ( cStack == NIL )
			cStack	:= __aPublicV[ nAT ][ 4 ]
		EndIF
		nAT			:= aScan( __aPublicV , { |aPublic| ( aPublic[ 1 ] == cVar ) .and. ( aPublic[ 4 ] == cStack ) } )
		IF ( nAT > 0 )
			IF ( cType == NIL )
				cType	:= __aPublicV[ nAT ][ 2 ]
			Else
				__aPublicV[ nAT ][ 2 ]	:= cType
			EndIF
			IF ( nSize == NIL )
				nSize	:= __aPublicV[ nAT ][ 3 ]
			Else	
				__aPublicV[ nAT ][ 3 ]	:= nSize
			EndIF
			IF ( cType == "A" )
				IF ( ( ValType( uSet ) == "A" ) .or. .NOT.( Type( cVar ) == "A" ) )
					_SetNamedPrvt( @cVar , aClone( uSet ) , @cStack )
				Else
					aSize( &cVar , @nSize )
				EndIF
			Else
				DEFAULT uSet	:= GetValType( @cType , @nSize )
				_SetNamedPrvt( @cVar , @uSet , @cStack )
			EndIF	
		EndIF
	EndIF

Return( nAT )

/*/
	Funcao:		GetCallStack
	Autor:		Marinaldo de Jesus 
	Data:		11/08/2011
	Descricao:	Retorna Array Com Pilha de Chamadas
	Sintaxe:	<vide parametros formais>
/*/
Static Function GetCallStack( nStart )
Return( StaticCall( NDJLIB001 , GetCallStack , @nStart ) )

Static Function __Dummy( lRecursa )
	Local oException
	TRYEXCEPTION
        lRecursa := .F.
		IF .NOT.( lRecursa )
			BREAK
		EndIF
    	lRecursa := __Dummy( .F. )
		INITSYSTEM()
		MDIGETACCESS()
	CATCHEXCEPTION USING oException
	ENDEXCEPTION
Return( lRecursa )