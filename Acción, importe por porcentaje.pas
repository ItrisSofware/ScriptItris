
begin {1}

  dsDetCom := ItsDsGetDetail (Delta, 'ERP_DET_COM');
  if (Assigned(dsDetCom)) then begin

    ValorBonif:= '';
    Ok := ItsInputQuery( 'Bonificaci�n por Importe', 'Ingrese el importe de la Bonificaci�n' , ValorBonif);
    if Ok = True then
        ValorBonif := ItsStrToFloat(ValorBonif);
    else
        exit;

{    if ValorBonif > 0 then begin

        Precio := ItsFlCurValue(dsDetCom, 'PRE_LIS');

        if Precio = 0 then begin
          ItsErr('El art�culo o el precio a�n no est�n asignados');
          Exit;
        end
}

{        if ValorBonif > Precio then begin
          ItsErr('La bonificaci�n no puede superar al precio de venta');
          Exit;
        end;
}
        if Precio > 0 then begin
            PorBonif := ValorBonif / Precio * 100;
            if PorBonif > 0 and PorBonif < 100 then
                ItsFlWCurValue(dsDetCom, 'POR_BONIFICACION', PorBonif);
        end;

     end
     else
         ItsErr('Importe Incorrecto');

  end;

end;{1}