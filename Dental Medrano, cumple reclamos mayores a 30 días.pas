begin
  Ahora := ItsExecuteFlQuery('select getdate()');
  DsReclamosAfectados := ItsDsOpenQuery('select estado_2, num_com, _NUMERO_RECLAMO, RAZON_SOCIAL from  ERP_COM_VEN ' +
                                        'where FK_ERP_T_COM_VEN = ''CRD'' ' +
                                        'and ESTADO_2 <> ''Anulado'' ' +
                                        'and ESTADO_2 <> ''Cumplido'' ' +
                                        'and NUM_COM not in (select _NUMERO_RECLAMO from ERP_COM_VEN where _NUMERO_RECLAMO <> '''' ) ' +
                                        'and FECHA < = GETDATE()-30; ');

  Count := ItsExecuteFlQuery('select count(*) from  ERP_COM_VEN ' +
                             'where FK_ERP_T_COM_VEN = ''CRD'' '+
                             'and ESTADO_2 <> ''Anulado'' ' +
                             'and ESTADO_2 <> ''Cumplido'' ' +
                             'and NUM_COM not in (select _NUMERO_RECLAMO from ERP_COM_VEN where _NUMERO_RECLAMO <> '''') ' +
                             'and FECHA < = GETDATE()-30; ');

  DsReclamosAfectados.First
  ItsSaveFile ('C:\Program Files (x86)\ITRIS\ItsClient\ReclamosCumplidos.txt', '::::::::::::::: ' + ItsVarAsString (Count) + ' RESULTADOS ENCONTRADOS ::::::::::::::' + _NEWLINE );
  ItsSaveFile ('C:\Program Files (x86)\ITRIS\ItsClient\ReclamosCumplidos.txt', 'Fecha y hora de inicio:' + ItsVarAsString(Ahora) + _NEWLINE );

  while not DsReclamosAfectados.EOF do begin
      NumCom := ItsFlCurValue(DsReclamosAfectados,'NUM_COM');
      RazSoc := ItsFlCurValue(DsReclamosAfectados,'RAZON_SOCIAL');
      ItsSaveFile ('C:\Program Files (x86)\ITRIS\ItsClient\ReclamosCumplidos.txt', ' Reclamo Nº: ' + NumCom + '| Razón Social: ' + RazSoc);

      DsReclamosAfectados.Next;
  end;

  ItsSaveFile ('C:\Program Files (x86)\ITRIS\ItsClient\ReclamosCumplidos.txt', _NEWLINE + '::::::::::::::: ' + ItsVarAsString (Count)  + ' RECLAMOS ENCONTRADOS Y ACTUALIZADOS :::::::::::::::' );

      ItsExecuteCommand('update ERP_COM_VEN set ESTADO_2 = ''Anulado''  ' +
                        'where FK_ERP_T_COM_VEN = ''CRD'' ' +
                        'and ESTADO_2 <> ''Anulado'' ' +
                        'and ESTADO_2 <> ''Cumplido'' ' +
                        'and NUM_COM not in (select _NUMERO_RECLAMO from ERP_COM_VEN where _NUMERO_RECLAMO <> '''')  ' +
                        'and FECHA < = GETDATE()-30; ');
end;