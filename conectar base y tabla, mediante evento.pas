begin
	if UpDateKind = UkInsert then begin   
		sql := ('select * from ' +
				' LAHER_C_N.dbo.ERP_EMPRESAS '+
				' where ID = ' + ItsFlAsSqlStr(Delta, 'ID') ');

		if (sql = true ) then
      ItsInfo ('El campo ID existe en el .');

	end;
end;

select ID from LAHER_C_N.dbo.ERP_EMPRESAS where ID = '1';