
{Genera la relación entre comprobantes de ventas partiendo desde el presupuesto, mostrando como resultado el pedido y la factura, sino devuelvo grilla vacía.}

begin

  {Busco los remitos tipo RLI cuyo estado sea autorizados y los cumplo}                                                                                     

{sql := ('update ' +
        'ERP_COM_VEN set ESTADO = ''X'' '+
        ' where FK_ERP_T_COM_VEN = ' + ItsFlAsSqlStr(Delta, 'CAMPO') +' and (ESTADO = ''P'' or ESTADO=''A'') ');
  ItsWriteLn(sql);
ItsExecuteCommand(Sql);

 End

updateERP_COM_VEN .....
 }

 sql :=  ('select '+
         'D.FK_ERP_COM_VEN as FK_ERP_COM_VEN_D '+
         'from ERP_DET_COM O '+
         'join ERP_DET_COM D on D.FK_ERP_DET_COM = O.IDD '+
         'join ERP_COM_VEN VO on VO.ID = O.FK_ERP_COM_VEN '+
         'join ERP_COM_VEN VD on VD.ID = D.FK_ERP_COM_VEN '+
         'where o.FK_ERP_COM_VEN = ' + ItsFlAsSqlStr(Delta, 'FK_ERP_COM_VEN') + ' ' +
         'group by d.FK_ERP_COM_VEN, o.FK_ERP_COM_VEN');


var1 := ItsExecuteFlQuery(sql);

ItsCreateForm('ERP_EN_BASE_VEN', 'FK_ERP_COM_VEN_O',  var1, true);
end;


{
begin

sql=()

variable:= itsexecuteflquery(sql)


QuotedStr(variable); 
  ItsCreateForm('ERP_EN_BASE_VEN', 'FK_ERP_COM_VEN_O',  ItsFLCurValue(Delta, 'FK_ERP_COM_VEN'), true);
end;
}