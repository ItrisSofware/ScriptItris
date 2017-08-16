begin
  if ((MasterName = 'ERP_COM_VEN') or (MasterName = 'ERP_COM_COM')) then
    if ItsFlCurValue(MasterDelta, 'EST_INT') = 'Z' then exit;

  FiltroSucursal := '(FK_ERP_SUCURSALES in (select FK_ERP_SUCURSALES from ITRIS_USERS where USERNAME = ' +
    QuotedStr(ActUserName)+') )';

  {cambiar el buscador de depositos}
  ItsChangeFindFilter(Delta, 'FK_ERP_DEPOSITOS', FiltroSucursal);

  {filtrar la listas de precio que tienen la sucursal del usuario o la sucursal está vacia}
  {cambiar el buscador de listas de precio}
  ItsChangeFindFilter(Delta, 'FK_ERP_LIS_PRECIO',
    '(isnull(FK_ERP_SUCURSALES, '''') = '''') OR '+FiltroSucursal);

  {VG: comprobantes de servicios}
  if (MasterName = 'ERP_COM_VEN') or (MasterName = 'ERP_COM_COM') or (MasterName = 'ERP_COM_STO') or (MasterName = 'ERP_COM_SER') then
    ItsFLWCurValue(Delta, 'FK_ERP_DEPOSITOS', ItsFLCurValue(MasterDelta, 'FK_ERP_DEPOSITOS'));

  {VG: comprobantes de servicios}
  if (MasterName = 'ERP_COM_VEN') or (MasterName = 'ERP_COM_COM') or (MasterName = 'ERP_COM_SER') then begin
    if not ItsFlEmpty(MasterDelta, 'FK_ERP_CEN_COSTOS') then
      ItsFLWCurValue(Delta, 'FK_ERP_CEN_COSTOS', ItsFLCurValue(MasterDelta, 'FK_ERP_CEN_COSTOS'));
    if not ItsFlEmpty(MasterDelta, 'FK_ERP_UNI_NEG') then
      ItsFLWCurValue(Delta, 'FK_ERP_UNI_NEG', ItsFLCurValue(MasterDelta, 'FK_ERP_UNI_NEG'));
    if not ItsFlEmpty (MasterDelta,'FEC_ENTREGA') then
      ItsFLWCurValue(Delta, 'FEC_ENTREGA', ItsFLCurValue(MasterDelta, 'FEC_ENTREGA'));
  end;

  if (MasterName = 'ERP_COM_VEN') or (MasterName = 'ERP_COM_STO')  then
    ItsFLWCurValue(Delta, 'FK_ERP_LIS_PRECIO', ItsFLCurValue(MasterDelta, 'FK_ERP_LIS_PRECIO'));

  if (MasterName = 'ERP_COM_STO') then
    if not ItsFlEmpty(MasterDelta, 'FK_ERP_UNI_NEG') then
      ItsFLWCurValue(Delta, 'FK_ERP_UNI_NEG', ItsFLCurValue(MasterDelta, 'FK_ERP_UNI_NEG'));

  if (MasterName = 'ERP_COM_COM') then
    ItsFLWCurValue(Delta, 'FK_ERP_LIS_COM', ItsFLCurValue(MasterDelta, 'FK_ERP_LIS_COM'));

  ItsFlWCurValue(Delta, 'AUTORIZADO', False);
  ItsFlWCurValue(Delta, 'FK_ERP_DET_COM', 0);

  {Moneda}
  if MasterName = 'ERP_COM_COM' then begin
    if ItsFlEmpty(MasterDelta, 'FK_ERP_LIS_COM') then begin
      ItsFlwCurValue(Delta, 'FK_ERP_MON_PRE', ErpMonedaPorDefecto);
    end
    else begin
      {LG: reemplazar por ItsDsOpenQuery}
      dsLisCom := ItsdsOpenTable('ERP_LIS_COM', 'ID = ' + ItsFlAsSqlStr(MasterDelta, 'FK_ERP_LIS_COM'), '');
      if ItsFlCurValue(dsLisCom, 'FK_ERP_MONEDAS') <> 0 then
        ItsFlwCurValue(Delta, 'FK_ERP_MON_PRE', ItsFlCurValue(dsLisCom, 'FK_ERP_MONEDAS'))
      else
        ItsFlwCurValue(Delta, 'FK_ERP_MON_PRE', ErpMonedaPorDefecto);
    end;
  end;

  if (MasterName = 'ERP_COM_STO') then begin
    if not ItsFlEmpty(MasterDelta, 'FK_ERP_CEN_COSTOS') then
      ItsFLWCurValue(Delta, 'FK_ERP_CEN_COSTOS', ItsFLCurValue(MasterDelta, 'FK_ERP_CEN_COSTOS'));
  end;

  if (SelfMasterName = 'ERP_COM_VEN_FAC') or (SelfMasterName = 'ERP_COM_VEN_PED')then begin
    if ItsFlEmpty(Delta, 'FK_ERP_SUC_ENT') = True then
      ItsFlWCurValue(Delta, 'FK_ERP_SUC_ENT', ErpSucursalUsuarioActivo2);
  end;
end;