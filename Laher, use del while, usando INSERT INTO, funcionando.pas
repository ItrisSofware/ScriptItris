begin
    dsBusco := 'select ' +
               'ID, ' +
               'FK_ERP_ARTICULOS, ' +
               'FK_ERP_COLORES, ' +
               'FK_ERP_COLORES_PRE, ' +
               'COD_BARRA, ' +
               'COD_PROV ' +
               'from ERP_CMB_ART ' +
               'where ' +
               '_ESTADO = ''P'' ';

    dsDetCom := ItsDsOpenQuery(dsBusco);
    while not dsDetCom.Eof do begin
      { ItsExecuteCommand ( 'UPDATE ERP_COM_VEN SET _TIENE_DETALLE_AUT = 1 where ID = ' + ItsFlasSqlStr(dsDetCom,'ID') );}
        ItsExecuteCommand('insert into LAHER_CN.dbo.ERP_CMB_ART ' +
                          '(ID, '+
                          'FK_ERP_ARTICULOS, ' +
                          'FK_ERP_COLORES, ' +
                          'FK_ERP_COLORES_PRE, ' +
                          'COD_BARRA, ' +
                          'COD_PROV ' +
                          ') values '+
                          '( '+ ItsFLAsSQLStr(dsDetCom, 'ID')+',  '+
                                ItsFLAsSQLStr(dsDetCom, 'FK_ERP_ARTICULOS')+',  '+
                                ItsFLAsSQLStr(dsDetCom, 'FK_ERP_COLORES')+',  '+
                                ItsFLAsSQLStr(dsDetCom, 'FK_ERP_COLORES_PRE')+',  '+
                                ItsFLAsSQLStr(dsDetCom, 'COD_BARRA')+',  '+
                                ItsFLAsSQLStr(dsDetCom, 'COD_PROV')+ ' )');

         ItsExecuteCommand ( 'update ERP_CMB_ART set _ESTADO = ''E'' ');

      dsDetCom.Next;
    end;
end;