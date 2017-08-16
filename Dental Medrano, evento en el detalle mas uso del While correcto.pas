begin
  dsDetCom := ItsDsGetDetail (Delta, 'ERP_IMP_VEN_REC');
    hora := ItsExecuteFlQuery('select CONVERT (datetime,CONVERT(VARCHAR,GETDATE(),101),101)');


    if Assigned(dsDetCom) then begin
      ItsDsFirst(dsDetCom);
      NumCom := ItsFlCurValue(dsDetCom, 'FK_ERP_DEB_VEN');
      if NumCom = '' then exit;

       while not ItsDsEOF(dsDetCom) do begin

             NumComA := ItsFlCurValue(dsDetCom, 'FK_ERP_DEB_VEN');
             ItsWriteLn('UPDATE ERP_COM_VEN set _fecha_ult_mov = ' + quotedstr(hora) + ' where id = ' + quotedstr(NumComA) );
             ItsExecuteCommand('UPDATE ERP_COM_VEN set _fecha_ult_mov = ' + quotedstr(hora) + ' where id = ' + quotedstr(NumComA) );
         ItsDsNext(dsDetCom);
      end;
    end;
end;