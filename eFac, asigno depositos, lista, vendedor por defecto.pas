begin
  //Recupero la sucursal.
  SqlSuc := ('select FK_ERP_SUCURSALES from ITRIS_USERS where USERNAME = ' + QuotedStr(ActUserName));
  Suc := ItsExecuteFlQuery(SqlSuc);
  
  //Recupero la lista de precios.
  SqlLisPre := ('select ID from ERP_LIS_PRECIO where FK_ERP_SUCURSALES = ' + QuotedStr(Suc));
  LisPre := ItsExecuteFlQuery(SqlLisPre);
  ItsFLWCurValue(Delta, 'FK_ERP_LIS_PRECIO', LisPre);
  
  //Recupero el depósito.
  SqlDep := ('select ID from ERP_DEPOSITOS where FK_ERP_SUCURSALES = ' + QuotedStr(Suc));
  Dep := ItsExecuteFlQuery(SqlDep);
  ItsFLWCurValue(Delta, 'FK_ERP_DEPOSITOS', Dep);
  
  //Recupero el vendedor.
  SqlVen := ('select ID from ERP_ASESORES where FK_ERP_SUCURSALES = ' + QuotedStr(Suc));
  Ven := ItsExecuteFlQuery(SqlVen);
  ItsFLWCurValue(Delta, 'FK_ERP_ASESORES', Ven);
end