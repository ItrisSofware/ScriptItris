begin
    //Si no sos auditor entonces hace lo siguiente.
    if ErpAuditor = false then begin

        //Traigo la sucursal del usuario activo.
        SucUsu := ItsExecuteFlQuery('select FK_ERP_SUCURSALES from ITRIS_USERS where USERNAME = ' + QuotedStr(ActUserName));

                    //Filtro por el campo sucursal según la suc del usuario devuelto en la variable SucUsu.
                    ActFilters.AddExpressionFilter('SUCUSU = ' + QuotedStr(SucUsu) );

    //Por Leo Condori
    end;
end;