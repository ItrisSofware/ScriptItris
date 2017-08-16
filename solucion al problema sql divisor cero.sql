select 
ITSWILDCARD_FECHAD as FECHAD,
ITSWILDCARD2_FECHAH as FECHAH,
D.FK_ERP_ARTICULOS as ID,
A.FK_ERP_AGR_ART,
A.FK_ERP_LIN_ART,
case (T.TIPO) when 'C' then SUM(D.CANTIDAD) * -1 else  SUM(D.CANTIDAD)end  as CAN_TOT,
case (T.TIPO) when 'C' then SUM(D.IMP_TOTAL) * -1 else  SUM(D.IMP_TOTAL)end as TOTAL,
AVG(D.PRECIO) as PRE_PROM,
(isnull(A.P_ULT_COMPRA,0) * (select top 1 COTIZACION from ERP_COTIZACIONES
where FK_ERP_MONEDAS = A.FK_ERP_MON_PUC 
order by FECHA desc
)) as ULT_COMP,
(case (T.TIPO) when 'C' then SUM(D.IMP_TOTAL) * -1 else  SUM(D.IMP_TOTAL)end)-(SUM(D.CANTIDAD)* (isnull(A.P_ULT_COMPRA,1) * (select top 1 COTIZACION from ERP_COTIZACIONES
where FK_ERP_MONEDAS = A.FK_ERP_MON_PUC 
order by FECHA desc
) ) ) as CMG,
--Editó PP y luego Leo.
case when isnull(A.P_ULT_COMPRA,1) <> 0 then
--listo
(((AVG(D.PRECIO)/(isnull(A.P_ULT_COMPRA,1) * (select top 1 COTIZACION from ERP_COTIZACIONES
where FK_ERP_MONEDAS = A.FK_ERP_MON_PUC 
order by FECHA desc )
))-1)*100) else 0 end as PORCEN,

case when SUM(V.PRECIO) <> 0 then

(((    ((case (T.TIPO) when 'C' then SUM(D.IMP_TOTAL) * -1 else  SUM(D.IMP_TOTAL)end)/ SUM(D.CANTIDAD) ) / V.PRECIO) -1)*100) else 0 end AS DESPRE1ACTUAL,
A.FK_ERP_TIP_ART, 
A._ESPECIALIDAD,
SS.TOT1 as S_TOTAL,
SS.CMG1 as S_CMG,

case when SS.TOT1 <> 0 then
(round((SS.CMG1/SS.TOT1),4,0)) * 100 else 0 end as S_PORCEN,
A.ORIGEN,
A.TIPO


from ERP_DET_COM D join ERP_ARTICULOS A
on D.FK_ERP_ARTICULOS = A.ID
left join ERP_PRE_VEN V on A.ID = v.FK_ERP_ARTICULOS
/*-----------------------------------------------------------*/
left join (select  SUM(TOTAL) as TOT1, SUM(CMG)as CMG1 from  _AS_EST_COS_RLI
WHERE  ( ( ITSWILDCARD_FECHAD is null)  or ( FECHA  >= ITSWILDCARD_FECHAD ) ) 
and  ( ( ITSWILDCARD2_FECHAH is null)  or ( FECHA < = ITSWILDCARD2_FECHAH ) )
 ) as SS on 1=1
/*-------------------------------------------------------------*/
join ERP_T_COM_VEN T on T.ID = D.TIP_COM 
and T.ID = 'RLI'

where  
V.FK_ERP_LIS_PRECIO in (SELECT ID FROM ERP_LIS_PRECIO WHERE DESCRIPCION LIKE 'Lista 1')
and  ( ( ITSWILDCARD_FECHAD is null)  or ( D.FECHA  >= ITSWILDCARD_FECHAD ) ) 
and  ( ( ITSWILDCARD2_FECHAH is null)  or ( D.FECHA < = ITSWILDCARD2_FECHAH ) )

group by D.FK_ERP_ARTICULOS,A.FK_ERP_AGR_ART,A.P_ULT_COMPRA,A.FK_ERP_LIN_ART, V.PRECIO, A.FK_ERP_TIP_ART, A._ESPECIALIDAD,SS.TOT1,SS.CMG1, A.ORIGEN, A.TIPO, A.FK_ERP_MON_PUC,T.TIPO

