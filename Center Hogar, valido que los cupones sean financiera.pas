begin
    if UpdateKind <> UkDelete then begin
  dsDetComTes := ItsDsGetDetail (Delta, 'ERP_DET_TES');
  if Assigned(dsDetComTes) then  begin
    //Pregunto si la cuenta del detalle es financiera.

    dsDetComTes.First;
    while not dsDetComTes.Eof do begin

        dsEsFin := ItsDsOpenQuery (
          'select _FINANCIERA from ERP_CUE_TES where ID = ' + ItsFlasSqlStr(dsDetComTes,'FK_ERP_CUE_TES')+
          ' and TIPO = ''T'' ' );

        if ItsDsRecordCount(dsEsFin) <> 0 then begin
          Cupon := ItsExecuteFlQuery (
              'select T.TIP_TAR from ERP_CUPONES C ' +
              'join ERP_TARJETAS T on C.FK_ERP_TARJETAS = T.ID ' +
              'where C.ID = ' + ItsFlasSqlStr(dsDetComTes,'FK_ERP_CUPONES') );

          if ItsFlCurValue(dsEsFin, '_FINANCIERA') = True then begin

            if Cupon <> 'F' then
              ItsRollBack ('Cuando el tipo de cuenta de tesorería está definida como Financiera el cupón no '+
                'puede usar una (Tarjeta/Financiera) distinta al tipo Financiera.');
          end;
          else begin
             if Cupon = 'F' then
              ItsRollBack ('Cuando el tipo de cuenta de tesorería está definida como Tarjeta el cupón no '+
                'puede usar una (Tarjeta/Financiera) del tipo Financiera.');
          end;
        end;
        dsDetComTes.Next;
    end;

  end;
  end;
end;