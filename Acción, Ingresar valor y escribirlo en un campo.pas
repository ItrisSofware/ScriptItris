begin
  Margen := '';
  Delta.First;
  if ItsInputQuery('Modificación de % de Utilidad','Ingrese nuevo % de Utilidad', Margen) = True then begin
    If ItsConfirm('Va modificar % de Utilidad de los artículos filtrados en la grilla. Desea seguir?', False) then begin
      Delta.First;
      while not Delta.EOF do begin
        ItsFlWCurValue(Delta,'POR_MARGEN', Margen);
        Delta.Post;
        Delta.Next;
      end;
    end;
  end;
end;