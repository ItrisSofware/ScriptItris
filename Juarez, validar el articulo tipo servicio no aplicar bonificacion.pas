{LC} {#36693} {No permitir aplicar bonificación a los artículos tipo servicios en los detalles de ventas}
begin

  dsDetCom := ItsDsGetDetail (Delta, 'ERP_DET_COM');

    if Assigned(dsDetCom) then begin

      ItsDsFirst(dsDetCom);
        while not ItsDsEOF(dsDetCom) do begin

             Art := ItsFlCurValue(dsDetCom, 'FK_ERP_ARTICULOS');
             Bon := ItsFlCurValue(dsDetCom, 'POR_BONIFICACION');

             Tipo := ItsExecuteFlQuery('select TIPO from ERP_ARTICULOS where ID = ' + ItsFlAsSqlStr(dsDetCom, 'FK_ERP_ARTICULOS') );

             if(Tipo = 'S')then begin
               if(Bon <> 0) or (ItsFlEmpty(dsDetCom, 'POR_BONIFICACION') = false ) then
                 ItsRollBack('No puede aplicar descuentos al artículo ' + ItsFlAsString(dsDetCom, 'FK_ERP_ARTICULOS') + ' porque no es un producto, es un servicio');
             end;

           ItsDsNext(dsDetCom);
        end;

    end;
end;