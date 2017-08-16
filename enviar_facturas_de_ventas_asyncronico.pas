begin
  sql := 'select C.ID as FK_ERP_COM_VEN, C.FK_ERP_EMPRESAS, C.RAZON_SOCIAL, isnull(C.CAE, '''') as CAE, ' +
                          ' isnull(TAL.GEN_FAC_ELEC, 0) as GEN_FAC_ELEC, T.* from ERP_COM_VEN_MAIL CM  ' +
                          ' join ERP_COM_VEN C on C.ID = CM.FK_ERP_COM_VEN ' +
                          ' join ERP_T_COM_VEN T on T.ID =  C.FK_ERP_T_COM_VEN and T.HABILITA_EM = 1 ' +
                          ' join ERP_TALONARIOS TAL on TAL.ID = C.FK_ERP_TALONARIOS ' +
                          ' where C.RAZON_SOCIAL <> ''ANULADO'' and isnull(CM.FEC_GEN, '''') = ''''  ';
  ItsWriteLn(sql);
  dsCom := ItsDsOpenQuery(sql);
  ItsDsFirst(dsCom);

    while not ItsDsEOF(dsCom) do begin
    {Si genera factura electrónica y tiene CAE asignado}
      if (ItsFlCurValue(dsCom, 'GEN_FAC_ELEC') = True) and (ItsFlCurValue(dsCom, 'CAE') <> '') then
        frmMail := ItsFrmCreate('ERP_COM_VEN_MAIL', True);
        ItsFrmAddFilter(frmMail, 'FK_ERP_COM_VEN', okEqual, ItsFlCurValue(dsCom, 'FK_ERP_COM_VEN') );
        dsMail :=  ItsFrmGetDataSet(frmMail);
        dsReports := ItsDsOpenQuery( 'select REPFK_ITRIS_CLASSES, REPNAME ' +
                                     ' from ITRIS_REPORTS ' +
                                     ' where REPID = ' + ItsFLAsSQLStr(dsCom, 'FK_ITRIS_REPORTS_EM') );

        Titulo := ItsFLCurValue(dsCom, 'TITULO_EM');
        Cuerpo := ItsFLCurValue(dsCom, 'CUERPO_EM');
        eMail := ItsExecuteFlQuery('select EMAIL from ERP_EMPRESAS where ID = ' + ItsFlAsSqlStr(dsCom, 'FK_ERP_EMPRESAS'));

        Adjunto := '';

        Adjunto := ItsClassSendReportToFile( ItsFlCurValue(dsReports, 'REPFK_ITRIS_CLASSES'),
                                             ItsFlCurValue(dsReports, 'REPNAME'), 'ID',
                                             ItsFlCurValue(dsCom, 'FK_ERP_COM_VEN'),
                                             itrpPDF,
                                             ItsFlCurValue(dsCom, 'FK_ERP_COM_VEN')
                                           );

        ItsFlWCurValue(dsMail, 'TITULO_MAIL', Titulo );
        ItsFlWCurValue(dsMail, 'CUERPO_MAIL', Cuerpo );
        ItsFlWCurValue(dsMail, 'EMAIL', eMail );
        ItsFlWCurValue(dsMail, 'FK_ITRIS_REPORTS', ItsFLCurValue(dsCom, 'FK_ITRIS_REPORTS_EM'));
        ItsFlWCurValue(dsMail, 'NOMBRE_ADJUNTO', Adjunto );
        ItsFlWCurValue(dsMail, 'ARCH_GEN_ASYN', True );
        ItsFlWCurValue(dsMail, 'FEC_GEN', Now );
        ItsFlWCurValue(dsMail, 'FEC_ULT_ACT', Now );       
        ItsFrmAccept(frmMail)
     dsCom.Next;
   end;
end;