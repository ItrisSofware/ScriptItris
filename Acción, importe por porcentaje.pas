
begin {1}

  dsDetCom := ItsDsGetDetail (Delta, 'ERP_DET_COM');
  if (Assigned(dsDetCom)) then begin

    ValorBonif:= '';
    Ok := ItsInputQuery( 'Bonificación por Importe', 'Ingrese el importe de la Bonificación' , ValorBonif);
    if Ok = True then
        ValorBonif := ItsStrToFloat(ValorBonif);
    else
        exit;

{    if ValorBonif > 0 then begin

        Precio := ItsFlCurValue(dsDetCom, 'PRE_LIS');

        if Precio = 0 then begin
          ItsErr('El artículo o el precio aún no están asignados');
          Exit;
        end
}

{        if ValorBonif > Precio then begin
          ItsErr('La bonificación no puede superar al precio de venta');
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