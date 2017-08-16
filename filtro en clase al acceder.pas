begin
SQL := ItsExecuteFlQuery ('select 1 from ITRIS_GRO_USE where MK_ITRIS_USERS ='+ QuotedStr(ActUserName) +' and ( MK_ITRIS_GROUPS = ''GCOM'' )'  );
if SQL = 1  then
begin
  ActFilters.AddExpressionFilter('FK_ERP_T_COM_VEN = ''PPL'' or FK_ERP_T_COM_VEN = ''PED''  ');
end;

end;