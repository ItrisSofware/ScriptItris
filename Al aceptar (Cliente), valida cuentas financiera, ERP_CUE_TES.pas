begin
    if UpdateKind <> UkDelete then begin
    if (ItsFlCurValue(Delta, 'TIPO') = 'T')  then begin

    if ItsConfirm('La cuenta que acaba de configurar es de uso exclusivo para financiera ', True) = True then
      ItsFlWCurValue(Delta, '_FINANCIERA', true);
    end;
  end;
end;