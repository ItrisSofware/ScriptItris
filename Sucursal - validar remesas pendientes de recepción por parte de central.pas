//_ERP_LOT_TES_CIE_VAL_REMESA - Al aceptar (en el cliente).
begin
  if UpDateKind <> UkDelete then begin
    if ItsFlCurValue(Delta, 'ABIERTO') = True then begin

      sql:= 'select COUNT(*) '+
            'from ERP_COM_TES C '+
            'join ERP_T_COM_TES T on T.ID = C.FK_ERP_T_COM_TES '+
            'where (T.REMESA = 1) and '+
            '      (T._REM_EFECTIVO = 1) and '+
            '      (C.FK_ERP_LOT_TES = '+ ItsFlAsSqlStr(Delta, 'ID') + ') '+
            'group by C.FK_ERP_LOT_TES ';
      CanRemesas:= ItsExecuteFlQuery(sql);

      if CanRemesas > 0 then begin

        sql:= 'select COUNT(*) '+
              'from ERP_COM_TES C '+
              'join ERP_T_COM_TES T on T.ID = C.FK_ERP_T_COM_TES '+
              'left join ERP_COM_TES RR on RR.FK_ERP_COM_TES = C.ID '+
              'where (T.REMESA = 1) and '+
              '      (T._REM_EFECTIVO = 1) and '+
              '      (RR.ID is NULL) and '+
              '      (C.FK_ERP_LOT_TES = '+ ItsFlAsSqlStr(Delta, 'ID') + ') '+
              '      group by C.FK_ERP_LOT_TES ';
        RemNoRendidas:= ItsExecuteFlQuery(sql);

        if RemNoRendidas > 0 then
          ItsRollBack('No es posible cerrar la caja, hay remesas de efectivo pendientes de recepción ');
      end;
    end;
  end;
end;