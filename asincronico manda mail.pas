begin

  Email := ItsExecuteFlQuery('select replace(_EMAIL_INFO, '','', '';'')  from ERP_PARAMETROS ');

  if Email <> '' then begin

    Titulo := 'Art�culos bajo punto de pedido ';
    Cuerpo := 'Env�o autom�tico de informe de Art�culos bajo punto de pedido por Sucursal al '+ DateToStr(Date());

    Adjunto := ItsClassSendReportToFile('_IMP_ERP_PED_STO',
                                        '_IMP_ERP_PED_STO',
                                        'ID', '1_1_',
                                        itrpPDF, 'Art�culos bajo punto de pedido');

    ItsMapiSendMail(Email, Titulo, Cuerpo, Adjunto, True);
  end;

end;