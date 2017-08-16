begin
    dsBusco := 'select ' +
             'D.TIP_COM, ' +
             'D.FK_ERP_COM_VEN_PED, ' +
             'D.FECHA, ' +
             'V.ID as ID, ' +
             'V._TIENE_DETALLE_AUT, ' +
             'V.ESTADO ' +
             'from ERP_DET_COM D ' +
             'join ERP_T_COM_VEN T on D.TIP_COM=T.ID ' +
             'join ERP_COM_VEN V on D.FK_ERP_COM_VEN_PED=V.ID ' +
             'where ' +
             'T.TIPO_DOC = ''P'' and ' +
             'D.AUTORIZADO = 1 and  ' +
             'V.ESTADO = ''A'' and ' +
             'ISNULL(V._TIENE_DETALLE_AUT, '''') = '''' ' +
             'GROUP BY D.TIP_COM, D.FK_ERP_COM_VEN_PED, D.FECHA, V.ID, V._TIENE_DETALLE_AUT, V.ESTADO ';

    dsDetCom := ItsDsOpenQuery(dsBusco);
    while not dsDetCom.Eof do begin

      ItsExecuteCommand ( 'UPDATE ERP_COM_VEN SET _TIENE_DETALLE_AUT = 1 where ID = ' + ItsFlasSqlStr(dsDetCom,'ID') );

      dsDetCom.Next; 
    end;
end;