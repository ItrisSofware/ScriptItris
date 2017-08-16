begin
  //Me meto en el detalle del comprobante
  DETALLE := ItsDsGetDetail(delta,'ERP_DET_GUI_TRA')
  DETALLE.FIRST


  //Comienzo a recorrer el detalle.
  WHILE NOT DETALLE.EOF DO BEGIN

    if (ItsflCurValue(detalle,'_BULTOS') > 0 ) then begin

        k := 1;
        while k <= ItsflCurValue(detalle,'_BULTOS') do begin

          IDD := ItsExecuteFlQuery('select max(IDD)+1 from _TEMP_ERP_DET_GUI_TRA ');
          PAG := ItsExecuteFlQuery('select COUNT(*)+1 from _TEMP_ERP_DET_GUI_TRA where FK_ERP_COM_VEN =  '+ ItsFlAsSqlStr(detalle, 'FK_ERP_COM_VEN') );

        //Ejecuto el insert.
          ItsExecuteCommand('insert into _TEMP_ERP_DET_GUI_TRA ' +
                          '(IDD, '+
                          ' FK_ERP_GUI_TRA, '+
                          ' FK_ERP_COM_VEN, '+
                          ' ESTADO, '+
                          ' OBSERVACIONES, '+
                          ' _BULTOS, '+
                          ' _CAMPOOCULTO, '+
                          ' _TRANSPORTE '+
                          ') values '+
                          '( '+ QuotedStr(IDD) +', '+
                               itsflassqlstr(detalle,'FK_ERP_GUI_TRA')+', '+
                               itsflassqlstr(detalle,'FK_ERP_COM_VEN')+', '+
                               itsflassqlstr(detalle,'ESTADO')+', '+
                               itsflassqlstr(detalle,'OBSERVACIONES')+', '+
                               itsflassqlstr(detalle,'_BULTOS')+', '+
                               QuotedStr(PAG) +', '+
                               itsflassqlstr(detalle,'_TRANSPORTE')+ ' )');

           itsexecutecommand('update ERP_DET_GUI_TRA set _CAMPOOCULTO = ' + quotedstr(PAG) + ' where IDD = ' + itsflassqlstr(detalle,'IDD'));
            //ItsWriteLn(upda);
           k := k + 1;

         end;

     end;
     DETALLE.NEXT;

  end;
           itsclassprintreport('_TEMP_ERP_DET_GUI_TRA','_ERP_ENV_DM_2','FK_ERP_GUI_TRA',ItsFlAsSqlStr(detalle, 'FK_ERP_GUI_TRA'), FALSE, TRUE);

end;