select 
ITSWILDCARD_FECHAD as FECHAD,
ITSWILDCARD2_FECHAH as FECHAH,
D.ID,
D.FK_ERP_AGR_ART,
D.FK_ERP_LIN_ART,
SUM(D.CAN_TOT) as CAN_TOT,
SUM(D.TOTAL) as TOTAL, 
AVG(PRE_PROM)as PRE_PROM,
MAX(ULT_COMP) as ULT_COMP,
( SUM(D.TOTAL)-(SUM(D.CAN_TOT)* isnull(MAX(D.ULT_COMP),1)   ) )as CMG,

--Editó esta línea
case when (MAX(D.ULT_COMP)-1) <> 0 then 
									      --else 0 end
((AVG(PRE_PROM)/(MAX(D.ULT_COMP)-1))*100  ) else 0 end as PORCEN,

--Editó esta línea
case when SUM(D.CAN_TOT) <> 0 then 

(((   (SUM(TOTAL)/ SUM(D.CAN_TOT) )                       --else 0 end 
/ (case V.PRECIO when 0 then 1 else V.PRECIO end)) -1)*100) else 0 end AS DESPRE1ACTUAL,

D.FK_ERP_TIP_ART, 
A._ESPECIALIDAD,
SS.TOT1 as S_TOTAL,
SS.CMG1 as S_CMG,

--Editó esta línea
case when SS.TOT1 <> 0 then 
                                     --agregó ELSE 0 end
(round((SS.CMG1/SS.TOT1),4,0)) * 100 else 0 end as S_PORCEN,

A.ORIGEN,
A.TIPO
from _AS_EST_COS_2 D
left join ERP_ARTICULOS A on A.ID = D.ID
left join ERP_PRE_VEN V on D.ID = V.FK_ERP_ARTICULOS
/*-----------------------------------------------------------*/
left join (select  SUM(TOTAL) as TOT1, SUM(CMG)as CMG1 from  _AS_EST_COS_2
WHERE  ( ( ITSWILDCARD_FECHAD is null)  or ( FECHA  >= ITSWILDCARD_FECHAD ) ) 
and  ( ( ITSWILDCARD2_FECHAH is null)  or ( FECHA < = ITSWILDCARD2_FECHAH ) )
 ) as SS on 1=1
/*-------------------------------------------------------------*/

where  
V.FK_ERP_LIS_PRECIO in (SELECT ID FROM ERP_LIS_PRECIO WHERE DESCRIPCION LIKE 'Lista 1')
and  ( ( ITSWILDCARD_FECHAD is null)  or ( D.FECHA  >= ITSWILDCARD_FECHAD ) ) 
and  ( ( ITSWILDCARD2_FECHAH is null)  or ( D.FECHA < = ITSWILDCARD2_FECHAH ) )

group by
D.ID,
D.FK_ERP_AGR_ART,
D.FK_ERP_LIN_ART,
V.PRECIO,
D.FK_ERP_TIP_ART, 
A._ESPECIALIDAD,
SS.TOT1,
SS.CMG1,
A.ORIGEN,
A.TIPO