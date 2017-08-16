begin                              
  Aux := ItsFrmCreate('ERP_COM_TES', False);
  ItsFrmOpen(Aux);

  dsComTes := ItsFrmGetDataSet(Aux);

  {abrir cheques diferidos}
  Sql := ('select ' +
          'P.ID, ' +
          'P.FK_ERP_CHEQUERAS, ' +
          'P.FK_ERP_BANCOS, ' +
          'P.ID as NUMERO, ' +
          'P.TIPO, ' +
          'P.FEC_EMI, ' +
          'P.DIAS, ' +
          'P.FEC_DEP, ' +
          'P.IMPORTE, ' +
          'P.FK_ERP_EMPRESAS, ' +
          'P.ORDEN, ' +
          'P.FK_ERP_CUE_TES, ' +
          '''D'' as TIPO_OCULTO, ' +
          'D.FK_ERP_CEN_COSTO, ' +
          'D.FK_ERP_UNI_NEG, ' +
          'D.FK_ERP_SUCURSALES ' +
          'from server3.sumpex.dbo.ERP_CHE_PRO P ' +
          'join ERP_CHEQUERAS C on C.ID = P.FK_ERP_CHEQUERAS ' +
          'join ERP_DET_TES D on D.FK_ERP_CHE_PRO = P.ID and D.REVERTIDO = 0 ' +
          'join ERP_CUE_TES T on  T.ID = D.FK_ERP_CUE_TES ' +
          'where C.TIPO = ''D'' and P.FK_ERP_CUE_TES = C.FK_ERP_CUE_TES and FEC_DEP <= GETDATE() ' +
          'order by P.FK_ERP_CUE_TES, D.IDD');

  ItsWriteLn(Sql);
  dsCheDif := ItsDsOpenQuery(Sql);

  while not dsCheDif.eof do begin
    Cuenta := ItsFlCurValue(dsCheDif, 'FK_ERP_CUE_TES');
    ItsFrmAppend(Aux);
    Unidades := 0;

    dsDetTes := ItsDsGetDetail(dsComTes, 'ERP_DET_TES');

    ItsFlWCurValue(dsComTes, 'FK_ERP_T_COM_TES', 'DCD');

    {aca tendria que ser para cada cheque}
    ItsWriteLn(ItsFlCurValue(dsCheDif, 'FK_ERP_CUE_TES'));

    while (not dsCheDif.eof) and (Cuenta = (ItsFlCurValue(dsCheDif, 'FK_ERP_CUE_TES'))) do begin
      ItsDsAppend(dsDetTes);
      ItsFlWCurValue(dsDetTes, 'FK_ERP_CUE_TES', ItsFlCurValue(dsCheDif, 'FK_ERP_CUE_TES'));
      ItsFlWCurValue(dsDetTes, 'FK_ERP_CEN_COSTO', ItsFlCurValue(dsCheDif, 'FK_ERP_CEN_COSTO'));
      ItsFlWCurValue(dsDetTes, 'FK_ERP_UNI_NEG', ItsFlCurValue(dsCheDif, 'FK_ERP_UNI_NEG'));
      ItsFlWCurValue(dsDetTes, 'TIPO', ItsFlCurValue(dsCheDif, 'TIPO_OCULTO'));
      ItsFlWCurValue(dsDetTes, 'FK_ERP_CHE_PRO', ItsFlCurValue(dsCheDif, 'ID'));
      Unidades := Unidades + ItsFlCurValue(dsDetTes, 'UNIDADES');
      dsDetTes.Post;
      dsCheDif.Next;
    end;

    //agregar contracuenta
    Sql := ('select FK_ERP_CUE_TES from ERP_CUE_TES where ID = ' + IntToStr(Cuenta));
    ItsWriteLn(Sql);
    ContraCue := ItsExecuteFlQuery(Sql);
    ItsWriteLn(ContraCue);
    ItsWriteLn(Unidades);

    ItsDsAppend(dsDetTes);
    ItsFlWCurValue(dsDetTes, 'FK_ERP_CUE_TES', ContraCue);
    ItsFlWCurValue(dsDetTes, 'UNIDADES', Unidades);
    ItsFlWCurValue(dsDetTes, 'TIPO', 'H');

    ItsFrmAccept(Aux);
  end;
  ItsDsClose(dsCheDif);
  {Cerrar el form}
  Aux.Free;
end;