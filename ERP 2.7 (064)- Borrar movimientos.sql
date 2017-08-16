/*
use layerp2_7_064
use interna

--select * from ITRIS_PARAMS

-- clases nuevas entre versiones
select 'delete from '+CLANAME, * 
from ITRIS_CLASSES 
where CLANAME like 'ERP_%' and CLASSTYPE = 'P' and
      CLANAME not in (select CLANAME from interna.dbo.ITRIS_CLASSES) 
order by CLANAME

-- clases viejas entre versiones
select CLANAME, * 
from interna.dbo.ITRIS_CLASSES 
where CLANAME like 'ERP_%' and CLASSTYPE = 'P' and
      CLANAME not in (select CLANAME from ITRIS_CLASSES) 
order by CLANAME

-- clases con registros
select C.CLANAME, I.rows, C.DISPLAYLABEL, I.NAME
from sysindexes I
join itris_classes C on C.classtype = 'P' and C.CLANAME = substring(I.NAME,4,255)
where name like 'PK_%' and rows > 0 
order by name

*/

-- Borra los movimientos del ERP 2.7.064

delete from ERP_ACT_CON_INS_AFIP
delete from ERP_ACT_FUN
delete from ERP_ACT_NO_RET_SUSS
delete from ERP_ACT_PRE
delete from ERP_ACT_PRE_COM
delete from ERP_AMORTIZACIONES 
delete from ERP_ANA_IND
delete from ERP_ANE_BIENES
delete from ERP_ANU_COM
delete from ERP_ANU_NUM
delete from ERP_ANU_PRO
delete from ERP_ANU_STO
delete from ERP_ANU_VEN
delete from ERP_ARCIBA
delete from ERP_ARIB
delete from ERP_ARIB_WEB
delete from ERP_ASI_CIE
delete from ERP_ASI_TRA
delete from ERP_ASIENTOS
delete from ERP_AUT_AUT_PED_PEN
delete from ERP_AUT_PED_CON
delete from ERP_C1116A
delete from ERP_C15_E
delete from ERP_C15_G
delete from ERP_C15_P
delete from ERP_C17
delete from ERP_CAL_ATRASO
delete from ERP_CAJAS
delete from ERP_CALC_COMI
delete from ERP_CALC_COMI_COB
delete from ERP_CAJ_LIS_EMP
delete from ERP_CAL_COS
delete from ERP_CAL_COS_CI
delete from ERP_CAL_PPP
delete from ERP_CAR_IMP
delete from ERP_CHE_PRO
delete from ERP_CHE_TER
delete from ERP_CIM_FIM
delete from ERP_CITI_COM
delete from ERP_CITI_VEN
delete from ERP_COM_BOR_SUC
delete from ERP_COM_COM
delete from ERP_COM_SER
delete from ERP_COM_STO
delete from ERP_COM_TES
delete from ERP_COM_VEN
delete from ERP_CON_FISCAL
delete from ERP_CON_MULTI
delete from ERP_CUA_I
delete from ERP_CUPONES
delete from ERP_DEP_INV
delete from ERP_DEP_PED
delete from ERP_DET_ACT_PRU
delete from ERP_DET_ASI
delete from ERP_DET_ART_GEN_CMB
delete from ERP_DET_CAJAS
delete from ERP_DET_COM
delete from ERP_DET_CONSUMOS
delete from ERP_DET_CON_BAN
delete from ERP_DET_CUE_LOT_TES
delete from ERP_DET_CUP_LIQ_TAR
delete from ERP_DET_GAS_LIQ_TAR
delete from ERP_DET_GUI_TRA
delete from ERP_DET_IMC
delete from ERP_DET_IMP_CC
delete from ERP_DET_IMP_OP
delete from ERP_DET_IMP_XLS
delete from ERP_DET_IMV
delete from ERP_DET_INV
delete from ERP_DET_LIS_EMP
delete from ERP_DET_LOT_LIQ_TAR
delete from ERP_DET_OBS
delete from ERP_DET_ORD_SER
delete from ERP_DET_PRO_CIM
delete from ERP_DET_RET_OP
delete from ERP_DET_RES_STO
delete from ERP_DET_STO_GUI_TRA
delete from ERP_DET_TES_OP
delete from ERP_DET_TECNICOS
delete from ERP_DET_TES
delete from ERP_DET_VTO_COM_VEN
delete from ERP_EST_RES
delete from ERP_EST_VEN
delete from ERP_ETIQUETAS
delete from ERP_EVO_PAT_NET
delete from ERP_EXP_REPROWEB
delete from ERP_FLU_EFE
delete from ERP_GAR_EXT_FAC
delete from ERP_GEN_AMORTIZACION
delete from ERP_GEN_ARC_PER
delete from ERP_GEN_ASI_AMO
delete from ERP_GEN_CF
delete from ERP_GEN_CMB
delete from ERP_GEN_CON_BAN
delete from ERP_GEN_DIARIO
delete from ERP_GEN_DIF_CAM
delete from ERP_GEN_EST
delete from ERP_GEN_FAC
delete from ERP_GEN_FAC_PLUS
delete from ERP_GEN_GLO_PRE
delete from ERP_GEN_IND
delete from ERP_GEN_INV
delete from ERP_GEN_MAT_PRI_PRO
delete from ERP_GEN_MOV_GRA
delete from ERP_GEN_NEC_PMP
delete from ERP_GEN_NUM_SER
delete from ERP_GEN_ONCCA
delete from ERP_GEN_PMP
delete from ERP_GEN_RECE
delete from ERP_GEN_SIT_PAT
delete from ERP_GEN_TRA
delete from ERP_GEN_UOCRA
delete from ERP_GRA_FIS 
delete from ERP_GUI_TRA
delete from ERP_IB_CORDOBA
delete from ERP_IB_LA_PAMPA
delete from ERP_IB_SAN_LUIS
delete from ERP_IDENTIFICADORES
delete from ERP_IMP_APOCRIFOS
delete from ERP_IMP_AUT_VEN
delete from ERP_IMP_COM
delete from ERP_IMP_DIARIO
delete from ERP_IMP_EMBARGO
delete from ERP_IMP_PAD_IB
delete from ERP_IMP_PAD_IB_AGIP
delete from ERP_IMP_PAD_MON_AGIP
delete from ERP_IMP_REPROWEB
delete from ERP_IMP_SUJ_EXE_GAN
delete from ERP_IMP_VEN
delete from ERP_IMP_XLS
delete from ERP_KILOMETRAJE
delete from ERP_LIM_CRE_SUC
delete from ERP_LIQ_TARJETAS
delete from ERP_LIS_EMP
delete from ERP_LOT_TES
delete from ERP_MAT_PRI_PRO
delete from ERP_MISIONES
delete from ERP_MOV_CF
delete from ERP_MUE_GRA
delete from ERP_NEC_PMP
delete from ERP_NOT_EST_CON
delete from ERP_NUM_SERIE
delete from ERP_ORD_ING
delete from ERP_ORD_PAG
delete from ERP_ORD_SER
delete from ERP_PED_GEN_PMP
delete from ERP_PER_EMBARQUE
delete from ERP_PMP
delete from ERP_REC_FAC_PLUS
delete from ERP_REC_RECE
delete from ERP_REG_ASI
delete from ERP_REG_CAU
delete from ERP_REG_NOV
delete from ERP_REN_ASI
delete from ERP_REN_COM_COM
delete from ERP_REN_COM_VEN
delete from ERP_REP_ND_REF
delete from ERP_RES_1361
delete from ERP_RES_830
delete from ERP_RET_COM
delete from ERP_RET_VEN
delete from ERP_REVERSIONES
delete from ERP_RG1784
delete from ERP_RG_IVA
delete from ERP_RG2300_AGR
delete from ERP_SAL_COMP_SUC
delete from ERP_SAL_DISP
delete from ERP_SIAP_GAN_SOC
delete from ERP_SIAP_IVA
delete from ERP_SICORE
delete from ERP_SIFERE
delete from ERP_SIJP
delete from ERP_SIMPLIFICACION
delete from ERP_SIT_PAT
delete from ERP_TIC_CAM_EMI
delete from ERP_TRA_PRO
delete from ERP_VTO_VEN

delete from ERP_MIG_FCO 
delete from ERP_MIG_FVE
delete from ERP_MIG_OC
delete from ERP_MIG_PED
delete from ERP_MIG_PRE
delete from ERP_MIG_RVE
delete from ERP_VALES
delete from ERP_GEN_RET_SICOSS 
delete from ERP_APL_GRU_OFE
delete from ERP_CON_FIS_REM_STO
delete from ERP_CUE_CREDITOS
delete from ERP_CREDITOS
delete from ERP_CUO_CRE
delete from ERP_GAR_CRE
delete from ERP_ART_CRE
delete from ERP_CRE_REF
delete from ERP_IMP_CUO_CRE
delete from ERP_GEN_ND_LOTE 
delete from ERP_GEN_CAR_RECL
delete from ERP_SIM_PLA
delete from ERP_TA_FE_WS
delete from ERP_DET_CAR_RECL
delete from ERP_DET_CUO_CRE
delete from ERP_DET_CRE_REF
delete from ERP_DEP_COM_VEN 
delete from ERP_DET_COM_HIS

delete from ERP_AUT_EN_LINEA
delete from ERP_CAL_COM_COB_VTA
delete from ERP_CAL_COM_VTA
delete from ERP_COM_PIC
delete from ERP_DET_ART_PIC
delete from ERP_DET_CUO_CRE_OTR_SUC
delete from ERP_DET_VTO_COM
delete from ERP_DIF_IVA_CUO
delete from ERP_ENT_OTR_SUC
delete from ERP_GEN_DIF_IVA_CUO
delete from ERP_GEN_PER_ARSV
delete from ERP_IMP_CUO_OTR_SUC
delete from ERP_PICKING
delete from ERP_REP_ND
delete from ERP_SAL_A_COB
delete from ERP_SIM_DET_COM
delete from ERP_SIM_DET_MED_PAG
delete from ERP_SIM_MED_PAG
delete from ERP_SIM_PLA_DET
delete from ERP_USU_CLA
delete from ERP_VTO_COM

delete from ERP_COTIZACIONES where ID <> 1 -- cotizacion 1 para la moneda pesos
update ERP_PAR_CF set FK_ERP_GEN_CF = null
update ERP_TALONARIOS set pro_num = 1
update ERP_CHEQUERAS set PRO_NUM = DES_NUM

-- SUELDOS (MOVIMIENTOS)
delete from ERP_NOVEDADES
delete from ERP_DAT_LIQ
delete from ERP_GEN_LIQ
delete from ERP_GEN_ASI_SUEL
delete from ERP_LIQUIDACIONES
delete from ERP_DET_LIQ
delete from ERP_LIQ_GAN 

/*
-- SUELDOS (DEFINICIONES)

delete from ERP_AFJP
delete from ERP_ANT_ANTERIOR
delete from ERP_ANTIGUEDADES
delete from ERP_ART
delete from ERP_ASIGNACIONES
delete from ERP_CALIFICACION
delete from ERP_CAR_INI_AGUI
delete from ERP_CAR_INI_GAN
delete from ERP_CON_LEG_CONT
delete from ERP_CON_LEGAJOS
delete from ERP_CONCEPTOS
delete from ERP_CONDICION
delete from ERP_CONTRATOS
delete from ERP_CONVENIOS
delete from ERP_DED_ACUM
delete from ERP_DED_ESP_GAN
delete from ERP_DED_ESP_LEG
delete from ERP_DED_GAN
delete from ERP_DED_GAN_PER
delete from ERP_DET_CON_MOD_CON
delete from ERP_DET_GRU_CON
delete from ERP_ESC_DIS_GAN
delete from ERP_FAMILIARES
delete from ERP_GRU_CON
delete from ERP_JUBILACIONES
delete from ERP_LEGAJOS
delete from ERP_MAX_DED_ESP
delete from ERP_MUTUALES 
delete from ERP_OBR_SOCIALES
delete from ERP_SIM_DOCU
delete from ERP_SIM_EVENTOS
delete from ERP_SIM_FORMA
delete from ERP_SIM_MODALIDAD
delete from ERP_SIM_PUESTO
delete from ERP_SINDICATOS
delete from ERP_SINIESTRADO
delete from ERP_SITUACION
delete from ERP_TRA_IMP
delete from ERP_TIP_EMPRESA
delete from ERP_ZONAS_AFIP
*/

-- PROYECTOS COMERCIALES
delete from ERP_PROYECTOS

-- CASHFLOW (INGRESOS Y EGRESOS)
delete from ERP_PRO_CF 

-- CONTRATOS (MOVIMIENTOS)
--update ERP_CAL_VEN set LIQUIDADO = 0, FK_ERP_COM_VEN = ''
--update ERP_NOV_SER set LIQUIDADO = 0, FK_ERP_COM_VEN = ''

/*
-- CONTRATOS (DEFINICIONES)
delete from ERP_ART_CON
delete from ERP_CAL_VEN
delete from ERP_CONT_CON
delete from ERP_CONT_SER
delete from ERP_IDE_CON
delete from ERP_TIP_CONTRATOS

delete from ERP_NOV_SER --????
*/


/*
-- SERVICIO TECNICO (DEFINICIONES)
delete from ERP_FALLAS
delete from ERP_MOD_ART
delete from ERP_PRI_SER
delete from ERP_PROBLEMAS
delete from ERP_PRUEBA
delete from ERP_T_PRUEBA
delete from ERP_T_SERVICIOS
delete from ERP_TEC_MOD
delete from ERP_TEC_ZONAS
delete from ERP_TECNICOS
*/

-- PARAMETRIZACION DEL ERP
/*
delete from ERP_ACUERDOS
delete from ERP_ACT_FIJ
delete from ERP_AGR_ART
delete from ERP_AGR_CF
delete from ERP_AGR_COM
delete from ERP_AGR_IND
delete from ERP_AGR_TES
delete from ERP_ART_DEP
delete from ERP_ART_PRO
delete from ERP_ART_SUS
delete from ERP_ART_UNI
delete from ERP_ARTICULOS
delete from ERP_ASESORES
delete from ERP_ASI_MOD
delete from ERP_ASO_ART_PLA
delete from ERP_BIN
delete from ERP_CAI_PRO
delete from ERP_CAJ_TES
delete from ERP_CAN_VENTAS
delete from ERP_CEN_COSTOS
delete from ERP_CHEQUERAS
delete from ERP_CHOFERES
delete from ERP_CLA_PROYECTOS
delete from ERP_CMB_ART
delete from ERP_COD_TARJETAS
delete from ERP_COE_IB_EMP
delete from ERP_COLORES
delete from ERP_COMBOS
delete from ERP_COMISIONES
delete from ERP_COMPRADORES
delete from ERP_CON_COM
delete from ERP_CON_PROTEICO
delete from ERP_CON_VEN
delete from ERP_CONTACTOS
delete from ERP_COS_FLETE
delete from ERP_CUE_CON
delete from ERP_CUE_TES
delete from ERP_DEF_IND
delete from ERP_D_ASI_MOD
delete from ERP_D_MOD_CON
delete from ERP_D_MOD_TES
delete from ERP_D_TIP_ASI
delete from ERP_DEPOSITOS
delete from ERP_DET_ALI_IB_TAR
delete from ERP_DET_ART_BON
delete from ERP_DET_BON
delete from ERP_DET_COMBOS
delete from ERP_DET_CUE_CAJ
delete from ERP_DET_FOR
delete from ERP_DET_INDICES
delete from ERP_DET_PRO
delete from ERP_DET_REC_CUO
delete from ERP_DET_TAR
delete from ERP_DET_TAR_COD_COM
delete from ERP_DET_VTO_CON
delete from ERP_DIMENSIONES
delete from ERP_DIR_ENTREGA
delete from ERP_EJERCICIOS
delete from ERP_EMPRESAS
delete from ERP_EST_PROYECTOS
delete from ERP_FERIADOS
delete from ERP_FORMACIONES
delete from ERP_FORMULAS
delete from ERP_GAS_ACT_FIJ
delete from ERP_GRADOS
delete from ERP_GRU_DEP
delete from ERP_GRU_EMP
delete from ERP_LIN_ART
delete from ERP_LIS_COM
delete from ERP_LIS_OFE_CON_VEN
delete from ERP_LIS_PRECIO
delete from ERP_MOD_CON
delete from ERP_MOD_TES
delete from ERP_MOT_DEV
delete from ERP_NOTAS
delete from ERP_ORI_EMP
delete from ERP_PAD_IB
delete from ERP_PAD_IB_AGIP
delete from ERP_PAD_MON_AGIP
delete from ERP_PAR_CF
delete from ERP_PAR_CON_FIS
delete from ERP_PAR_EXP_AGR
delete from ERP_PAR_GLO_PRE
delete from ERP_POLIZAS
delete from ERP_PER_EMP
delete from ERP_POS_ARE
delete from ERP_PRE_ART
delete from ERP_PRE_COM
delete from ERP_PRE_VEN
delete from ERP_PROCEDENCIAS
delete from ERP_PROCESOS
delete from ERP_PROMOCIONES
delete from ERP_PUN_VEN
delete from ERP_RAN_PROYECTOS
delete from ERP_RAZ_SOCIALES
delete from ERP_REC_AUT
delete from ERP_REL_CON
delete from ERP_RES_PROYECTOS
delete from ERP_RET_EMP
delete from ERP_REVALUO
delete from ERP_RUBROS
delete from ERP_SEG_T_COM_COM
delete from ERP_SEG_T_COM_STO
delete from ERP_SEG_T_COM_TES
delete from ERP_SOC_HEC
delete from ERP_SUB_EST_CAR
delete from ERP_SUCURSALES
delete from ERP_TARJETAS
delete from ERP_T_ACT_FIJ
delete from ERP_T_COB_POLIZA
delete from ERP_TIP_ART
delete from ERP_TIP_ASI		
delete from ERP_TIP_CARGA
delete from ERP_TIP_CEN
delete from ERP_TIP_EMP
delete from ERP_TRANSPORTES
delete from ERP_UBICACIONES
delete from ERP_UNI_NEG
delete from ERP_UNI_VEN
delete from ERP_ZONAS
delete from ERP_AGR_CUE 
delete from ERP_TAL_VAL
delete from ERP_CONF_POSNET 
delete from ERP_TIP_CTA_CRE
delete from ERP_PLA_FIN
delete from ERP_SEG_T_COM_VEN 
delete from ERP_GRU_OFE
delete from ERP_INT_POR_CUO
delete from ERP_CON_LIS_PRE

delete from ERP_ART_ASO
delete from ERP_ART_PLA
delete from ERP_COM_COB_VTA
delete from ERP_COM_VTA
delete from ERP_DET_ASESORES
delete from ERP_DET_CLA_ART
delete from ERP_DET_COBRADORES
delete from ERP_DET_COD_COM
delete from ERP_DET_COM_COB_VTA
delete from ERP_DET_COM_VTA
delete from ERP_DET_CUO_PLA
delete from ERP_DET_REC_FIN
delete from ERP_DET_SUC
delete from ERP_DET_SUC_PLA
delete from ERP_DET_TARJETAS
delete from ERP_DET_UNI_NEG
delete from ERP_GLP_PRECIOS
delete from ERP_OFE_SUC
delete from ERP_PRO_BCO
delete from ERP_SER_POR_ART

delete from ITRIS_CLATASKS

*/

/*

-- TABLAS FIJAS DEL ERP (se copian siempre)
ERP_CAT_IVA
ERP_TIP_DOC
ERP_T_COM_AFIP

-- TABLAS CON VALORES POR DEFECTO DEL ERP (vienen con datos de INIERP)
ERP_ALICUOTAS		
ERP_ALI_RET
ERP_BANCOS
ERP_CLA_SUC
ERP_DESTINOS
ERP_ESPECIES
ERP_INCOTERMS
ERP_INDICES
ERP_LOCALIDADES
ERP_MOD_FISCAL
ERP_MONEDAS
ERP_PAISES
ERP_PARAMETROS	
ERP_PARTIDOS
ERP_PRO_ONCCA
ERP_PROVINCIAS
ERP_T_COM_COM 		
ERP_T_COM_STO		
ERP_T_COM_TES		
ERP_T_COM_VEN		
ERP_TALONARIOS		
ERP_TIP_RET		
ERP_TIP_TAL		
ERP_TOP_RET
ERP_TRA_RET		

-- TABLAS DE INTEGRA (se copian siempre por ahora)
ITRIS_ACTIONS
ITRIS_ASYNC
ITRIS_ATTRIBUTES
ITRIS_CLASSES
ITRIS_CLA_PARAMS
ITRIS_EVE_LIB
ITRIS_EVENTS
ITRIS_INDEXS
ITRIS_LIBS
ITRIS_MENU
ITRIS_PARAMS
ITRIS_REPORTS	
ITRIS_WKDOCS
ITRIS_WKFILTERS
ITRIS_WKRELATIONS
ITRIS_WKRELMAPS

ITRIS_CUB_VIEWS
ITRIS_GRD_VIEWS	

-- NO SE COPIAN POR AHORA
ITRIS_ACT_LAYERS
ITRIS_GEN_LAYERS
ITRIS_LAY_ATTRS

-- TABLAS DE INTEGRA DE SEGURIDAD
ITRIS_GRO_ACT
ITRIS_GRO_ATT
ITRIS_GRO_CLA
ITRIS_GRO_USE
ITRIS_GRO_RSC
ITRIS_GROUPS
ITRIS_RESOURCES
ITRIS_RSCGROUPS
ITRIS_USERS

*/

-- MOVIMIENTOS DE INTEGRA (hay que forzar la reconstruccion, se pueden borrar)
delete from ITRIS_CHANGEPASSWORD
delete from ITRIS_FORCEPASSWORD
delete from ITRIS_IDSVALUES
delete from ITRIS_TASKS
delete from ITRIS_LOG
delete from ITRIS_MAILS
delete from ITRIS_REBCLASS
delete from ITRIS_REBDB
delete from ITRIS_LNK_FILES -- habria que ver si es valido siempre, puede ser archivos de articulos como planos
delete from ITRIS_VAL_BUS
delete from ITRIS_UNDOLOG

update ITRIS_LOGCACHED set CLALASTUPDATE = getdate()

-- PASOS
-- migrar las tablas de integra
-- borrar los movimientos
-- reconstruir las clases
-- revisar parametrizacion

