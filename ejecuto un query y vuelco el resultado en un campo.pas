begin

Cotizacion :=  ItsExecuteFlQuery('select top 1 COTIZACION ' +
                                 ' from ERP_COTIZACIONES where ' +
                                 ' FECHA <= ' +  ItsFlAsSqlStr(Delta, 'FECHA') + ' and FK_ERP_MONEDAS = ''2'' order by FECHA desc;');

        ItsFlWCurValue(Delta, '_ERP_COTIZACION', Cotizacion);
end;