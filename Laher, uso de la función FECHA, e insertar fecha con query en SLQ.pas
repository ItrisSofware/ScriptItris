{ULTIMA LINEA DEL EVENTO: Actualizo fecha y hora de la actualizacion del registro}
function ItsVarAsSQLStr(Value: variant): string;
begin
  S := 'yyyy/mm/dd';
  if Frac(Value) > 0 then
    S := S + ' hh:mm';
  Result := QuotedStr(FormatDateTime(S, Value));
end;

begin

  if UpdateKind <> UkDelete then begin
    Fec := ItsVarAsSQLStr(Now());
    ItsExecuteCommand('update ERP_COLORES set FEC_ULT_ACT = ' + Fec + ' where FEC_ULT_ACT is null ' );
  end;
end;