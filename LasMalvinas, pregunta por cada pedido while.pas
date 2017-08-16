begin
  dsDetCom := ItsDsGetDetail (Delta, 'ERP_DET_COM');

    if Assigned(dsDetCom) then begin
      ItsDsFirst(dsDetCom);
        while not ItsDsEOF(dsDetCom) do begin

             Art := ItsFlCurValue(dsDetCom, 'FK_ERP_ARTICULOS');
             Dep := ItsFlCurValue(dsDetCom, 'FK_ERP_DEPOSITOS');

             DesDep := ItsExecuteFlQuery('select DESCRIPCION from ERP_DEPOSITOS where ID = ' + ItsFlAsSqlStr(dsDetCom, 'FK_ERP_DEPOSITOS') );

             if ItsConfirm('¿Realmente desea descontar el artículo ' + ItsVarAsString(Art) + ' del deposito ' + ItsVarAsString(DesDep) + ' ?', False) = False then begin
             ItsRollBack('Por favor ahora cambie el depósito del artículo ' + ItsVarAsString(Art) + ' .');
             end;
          ItsDsNext(dsDetCom);
        end;
    end;
end;