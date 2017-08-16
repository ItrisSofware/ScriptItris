begin
  if UpdateKind <> UkDelete then begin

    SQL := 'Select count(*) ' +
           ' from _ERP_CIE_DIA_SUC ' +
           'where FK_ERP_SUCURSALES = ' + ItsFlAsSqlStr(Delta, 'FK_ERP_SUCURSALES')  + ' and DIA = ' + ItsFlAsSqlStr(Delta, 'DIA');

    if UpdateKind = UkModify then
      SQL := SQL + ' and  ID <> ' + ItsFlAsSqlStr(Delta, 'ID');

    DsNF:= ItsExecuteFlQuery (SQL);
    if DsNF <> 0 then
      ItsRollBack ('La sucursal y ese día ya existen.');
  end;
end;