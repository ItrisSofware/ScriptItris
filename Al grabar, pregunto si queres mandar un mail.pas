begin
  if ItsConfirm('¿Desea enviar mail con el remito adjunto al depósito?', True) = True then begin
    Titulo := 'Egreso de Remito de ventas Nº '  + ItsFlAsString(Delta, 'NUM_COM') +
              ' del cliente ' + ItsFlAsString(Delta, 'RAZON_SOCIAL');
    RazSoc := ItsExecuteFlQuery ('select fk_erp_raz_sociales from ERP_T_COM_VEN where ID ='  + ItsFlasSqlStr(Delta, 'FK_ERP_T_COM_VEN') );
    Email :=  ItsExecuteFlQuery ('select _EMAIL from ERP_RAZ_SOCIALES where id = ' + QuotedStr(RazSoc)  );
    Adjunto :=ItsClassSendReportToFile('ERP_IMP_FAC', 'ERP_Factura A', 'NUM_COM', ItsFlAsString(Delta, 'NUM_COM'), itrpPDF, 'Remito');
    Cuerpo := ('Se adjunta el remito de ventas ' + ItsFlAsString(Delta, 'NUM_COM') );
    ItsMapiSendMail(Email, Titulo, Cuerpo, Adjunto, True);
    end;
end;