begin

  Email := ItsExecuteFlQuery('select replace(_EMAIL_INFO, '','', '';'')  from ERP_PARAMETROS ');

  if Email <> '' then begin

    Titulo := 'Artículos bajo punto de pedido ';
    Cuerpo := 'Envío automático de informe de Artículos bajo punto de pedido por Sucursal al '+ DateToStr(Date());

    Adjunto := ItsClassSendReportToFile('_IMP_ERP_PED_STO',
                                        '_IMP_ERP_PED_STO',
                                        'ID', '1_1_',
                                        itrpPDF, 'Artículos bajo punto de pedido');

    ItsMapiSendMail(Email, Titulo, Cuerpo, Adjunto, True);
  end;

end;