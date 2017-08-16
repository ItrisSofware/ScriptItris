
begin
ItsExecuteCommand('UPDATE ERP_COM_VEN SET FK_ERP_ASESORES = ''48'' WHERE ISNULL(FK_ERP_ASESORES, '''')='''' and (FK_ERP_T_COM_VEN = ''CRM'') ');
end;