begin
  if UpDateKind <> UkDelete then begin

    SucUsu := ItsExecuteFlQuery ('select fk_erp_sucursales from ITRIS_USERS where username  = ' + QuotedStr(ActUserName));

     SucRis := ItsExecuteFlQuery ('Select count(*) from ERP_RES_RIS where ESTADO = ''P'' and FK_ERP_SUC_DES  = ' + QuotedStr(SucUsu) );

     if SucRis > 0  then
       ItsRollBack ('No puede cerrar caja. Tiene ingresos (RIS) de stock pendientes.');
  end;
end;