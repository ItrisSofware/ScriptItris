// Se restinge la exportacion de datos ( de CC a las Notebook ) en la franja horaria de 6:00 a 9:00

// ACRALRACION !!!!  SE PUSO MONENTANEAMENTE  LA FRANJA HORARIA DE 6 A 13 PARA CENTRALIZAR CAMION 9


// Solo la exportacion
{
Valores posibles del campo EST_EXP_SUC:
A    a procesar
E    en proceso
V    error de validacion
T    error de conexion
P    procesado
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////              FUNCIONES Y PROCEDIMIENTOS DE ADO                /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////



Function AdoCreateConnection(Servidor:String; Base:String; var Error:Boolean);    //OK
begin
   Result := ItsADOCreateConnection('Provider=SQLOLEDB;Integrated Security=SSPI;Persist Security Info=False;Prompt=3;' +
                                    'Initial Catalog=' + Base + ';' +
                                    'Data Source=' + Servidor );
end;

Function AdoDsOpenQuery(Conn; Query:String);       //OK
begin
  Result := ItsADOOpenQuery(Conn, Query);
end;

function AdoDsOpenTable(Conn; TableName:String; Query:String);    //OK
begin
  Result := ItsADOOpenTable(Conn, TableName, Query, '');
end;

Function AdoExecuteFlQuery(Conn; Query:String);    //OK
begin
  Result := ItsADOExecuteFLQuery(Conn, Query);
end;

Procedure ADOExecuteCommand(Conn; Query:String);    //OK
begin
  ItsADOExecuteCommand(Conn, Query);
end;

Procedure AdoDsAppend(dsDatos);    //OK
begin
  ItsDsAppend(dsDatos);
end;

Procedure AdoDsFirst(dsDatos);    //OK
begin
  ItsDsFirst(dsDatos);
end;

Procedure AdoFlCurValue(dsDatos; FieldName:String);    //OK
begin
  Result := ItsFlCurValue(dsDatos, FieldName);
end;

Procedure AdoFlWCurValue(dsDatos; FieldName:string; Valor);    //OK
begin
  ItsFlWCurValue(dsDatos, FieldName, Valor);
end;

Procedure AdoDsPost(dsDatos);    //OK
begin
  ItsDsPost(dsDatos);
end;

Procedure AdoDsNext(dsDatos);    //OK
begin
  ItsDsNext(dsDatos);
end;

Procedure AdoDsDelete(dsDatos);    //OK
begin
  ItsDsDelete(dsDatos);
end;

Function AdoDsEof(dsDatos):boolean;    //OK
begin
  Result := ItsDsEof(dsDatos);
end;

Procedure AdoDsClose(dsDatos);    //OK
begin
  ItsDsClose(dsDatos);
end;

////////////////////////////////////////////////////////////////////////////////

function AdoCloseConnection(Conn);
begin
  Result := Conn.Close ;
end;

Function AdoFieldType(dsDatos; FieldName:String);
begin
  Result := ItsADOFieldTypeByName(dsDatos, FieldName);
end;

Function AdoEsImagen(dsDatos; FieldName:String):boolean;
begin
 if AdoFieldType(dsDatos, FieldName) = 15 then
    Result := TRUE
  else
    Result := FALSE ;
end;

Function AdoEsFecha(dsDatos; FieldName:String):boolean;
begin
 if AdoFieldType(dsDatos, FieldName) = 11 then
    Result := TRUE
  else
    Result := FALSE ;
end;

Function AdoEsString(dsDatos; Campo:String):Boolean;
begin
  if AdoFieldType(dsDatos, Campo) = 1 then
    Result := TRUE
  else
    Result := FALSE;
end

Function AdoEsBoolean(dsDatos; Campo:String):Boolean;
begin
  if AdoFieldType(dsDatos, Campo) = 5 then
    Result := TRUE
  else
    Result := FALSE;
end

Function AdoFlAsSqlStr(dsDatos;FieldName:String): string;
begin
  if ItsFlEmpty(dsDatos, FieldName) = True then begin
    if AdoEsString(dsDatos, FieldName) = True then
      Result := QuotedStr('')
    else
      Result := 'null';
    Exit;
  end;
  if AdoEsBoolean(dsDatos, FieldName) = True then begin
    if ItsFlCurValue(dsDatos, FieldName) = True then
      Result := '1'
    else
      Result := '0';
    Exit;
  end;
  Result := ItsFlAsSqlStr(dsDatos, FieldName);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////                FUNCIONES Y PROCEDIMIENTOS EN GENERAL          /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

{
function ErpSucursalUsuarioActivo: String;
begin
  Result := ItsExecuteFlQuery('select FK_ERP_SUCURSALES from ITRIS_USERS where ' +
    'USERNAME like ' + QuotedStr(ActUserName));
end;
 }
procedure GrabarSQL(C: String ;S: String);
begin
  ItsSaveFile( ItsCompleteFileName( C, 'SQL'), S);
end;

procedure BorrarSQL(C: String);
begin
  ItsDeleteFile( ItsCompleteFileName( C, 'SQL') );
end;

procedure GrabarLog(S: String);
begin
  if S <> '' then
    S := FormatDateTime('dd/mm/yyyy hh:mm:ss', Now ) + ' ' + S;
  ItsSaveFile( ItsCompleteFileName('Centralizacion', 'LOG'), S);
end;

Function ExtraerIni(var S: String; Separador: String): String;
begin
  Can := Pos(Separador, S);
  if Can = 0 then begin
    Can := Length(S) + 1;
  end;
  Result := TrimRight(Copy(S, 1, Can-1));
  Delete(S, 1, Can);
end;

Function ExtraerFin(var S: String; Separador: String): String;
begin
  Can := Pos(Separador, S);
  if Can = 0 then begin
    Can := Length(S) + 1;
  end;
  Result := TrimLeft(Copy(S, (Can+1), (Length(S)-Can)));
  Delete(S, 1, Can);
end;

Function ExtraerSig(var S: String; var X: String ; Separador: String): Boolean;
begin
  Can := Pos(Separador, X);
  if Can = 0 then begin
    Can := Length(X) + 1;
  end;
  S := TrimRight(Copy(X, 1, Can-1));
  Delete(X, 1, Can);
  if Length(X) = 0 then
    Result := FALSE
  else
    Result := TRUE;
end;

Function ConvFiltro(Filtro:String):String;
begin
  Result := ItsStringReplace(Filtro,'ITSWILDCARD_SUCURSAL',QuotedStr( ErpSucursalUsuarioActivo ));
end;

{Busco la clase padre de la clase informada}
Function TablaPadre(TableName:String):String;
begin
  lSigue := True;
  while lSigue do begin
    Padre := ItsExecuteFlQuery('select FK_ITRIS_CLASSES from ITRIS_CLASSES ' +
                               'where CLANAME = ' + QuotedStr(TableName) );
    if Padre = '' then
      lSigue := False
    else
      TableName := Padre ;
  end;
  Result := TableName
end;

{Valido si la clase es de tipo objeto: Tabla}
Function Es_Tabla(TableName:String):Boolean;
begin
  TipoObjeto := ItsExecuteFlQuery('select CLASSTYPE from ITRIS_CLASSES ' +
                                 'where CLANAME = ' + QuotedStr(TableName) );
  if TipoObjeto = 'P' then
    Result := TRUE
  else
    Result := FALSE;
end;

Function Existe_Campo(TableName:String; XCampo:String):Boolean;
begin
  Result := ItsExecuteFlQuery('select count(*) from ITRIS_ATTRIBUTES ' +
                               'where MK_ITRIS_CLASSES =  ' + QuotedStr(TableName) +
                               ' and ATTNAME = ' + QuotedStr(XCampo)) > 0;
end;

Function ExisteComprobante(Conn, TableName; Clave; IDClave: String):Boolean;
begin
  Result := FALSE;
  dsAux := AdoDsOpenQuery(Conn, 'select * from '+ TableName +' where ' + Clave + ' = ' + QuotedStr( IDClave ));
  if dsAux.RecordCount > 0 then
    Result := TRUE;
  AdoDsClose(dsAux);
end;

Function IDNextValue(Conn, TableName:String; Clave:String; var UltimoID:Integer):Integer;
begin
  IdsAttribute := TableName +';'+ Clave ;
  
  dsIDSValues := AdoDsOpenTable(Conn,'ITRIS_IDSVALUES','IDS_ATTRIBUTE = ' + QuotedStr(IdsAttribute));

  if (dsIDSValues.RecordCount = 0) or (AdoDsEof(dsIDSValues)) then begin
    AdoDsAppend(dsIDSValues);
    AdoFlWCurValue(dsIDSValues, 'IDS_ATTRIBUTE' ,IdsAttribute);
    AdoFlWCurValue(dsIDSValues, 'IDS_STEPBY' , 1);
    AdoFlWCurValue(dsIDSValues, 'IDS_VALUE' , UltimoID );
    AdoDsPost(dsIDSValues);
  end;

  {Si no hay registro pongo en 0 IDS_VALUE para que arranque de 1 }
  if UltimoID = 0 then
    Proximo := 1
  else
    Proximo := AdoFLCurValue(dsIDSValues, 'IDS_VALUE') + 1 ;

  {Valido el ultimo con el que informa la tabla ITRIS_IDSVALUES}
  if UltimoID > Proximo then
    Proximo := UltimoID + 1 ;

  UltimoID := Proximo;

  AdoFlWCurValue(dsIDSValues, 'IDS_VALUE' , Proximo );
  AdoDsPost(dsIDSValues);

  {Close}
  AdoDsClose(dsIDSValues);

  Result := Proximo ;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////// EXPORTACION DE CLASES DESDE CASA CENTRAL HACIA LAS SUCURSALES /////////////////////////
//////////////////////               SE LEE POR ITS Y DE GRABA POR ADO               /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


{Baja de los detalles de la clase}
Procedure BajaDetalle(Conn; TableName:String; Clave:String; IDClave );
begin
  dsDetalle := ItsDsOpenQuery('select FK_ITRIS_CLASSES, ATTFK_ITRIS_ATTRIBUTES2 ' +
                              'from ITRIS_ATTRIBUTES ' +
                              'where LOGICTYPE = ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );

  {Si existen detalles doy de baja cada uno de los detalles}
  ItsDsFirst(dsDetalle);
  while not ItsDsEof(dsDetalle) do begin

    TablaDetalle := TablaPadre( ItsFlCurValue(dsDetalle,'FK_ITRIS_CLASSES'));
    ClaveDetalle := ItsFlCurValue(dsDetalle,'ATTFK_ITRIS_ATTRIBUTES2');
    ExtraerFin(ClaveDetalle,';');

    {Valido que la clase sea una tabla y no una consulta}
    if (Es_Tabla(TablaDetalle) = True) then begin

      // and (Existe_Campo(TablaDetalle,'FEC_ULT_ACT') = False)

      {Baja del detalle}
      dsBajaDetalle := AdoDsOpenTable(Conn, TablaDetalle , ClaveDetalle + ' = ' + QuotedStr( IDClave ) );
      if dsBajaDetalle.RecordCount > 0 then begin
        AdoDsFirst(dsBajaDetalle);
        while not AdoDsEof(dsBajaDetalle) do begin
          AdoDsDelete(dsBajaDetalle);
        end;
      end;
      AdoDsClose(dsBajaDetalle);
    end;

    ItsDsNext(dsDetalle);
  end;
  ItsDsClose(dsDetalle);
end;

{Bajas segun auditoria }

Procedure Baja(Conn; TableName:String; Clave:String; CondiBaja:String; var ActualizaCache:Boolean);
begin
  {PP} { 30967 : Centralizador no esta informando correctamente las bajas de casa central a las sucursales}
  ClaveClase := ItsExecuteFlQuery('select CLAKEYFIELD from ITRIS_CLASSES ' +
                                  'where CLANAME = ' + QuotedStr( TableName ));
  {Busco bajas de maestros en la auditoria }
  dsBaja := ItsDsOpenQuery('select KEYVALUE from ITRIS_LOG ' +
                           'where CLASSNAME = ' + QuotedStr( TableName ) + ' and ' +
                           'OPKIND = ''D'' and ATTRIBUTENAME = ' + QuotedStr(ClaveClase) + ' and ' + CondiBaja ) ;
  ItsDSFirst(dsBaja);
  while not ItsDsEof(dsBaja) do begin
    IDClave := ItsFlCurValue(dsBaja, 'KEYVALUE') ;
    GrabarLog('Baja: ' + TableName + ' ' + ClaveClase + ' = ' + QuotedStr( IDClave ));
    dsAux := AdoDsOpenTable(Conn, TableName, ClaveClase + ' = ' + QuotedStr( IDClave ));
    if dsAux.RecordCount > 0 then begin
      if not AdoDsEof(dsAux) then begin
        BajaDetalle(Conn, TableName, Clave, IDClave );
        AdoDsDelete(dsAux);
        ActualizaCache := True;
      end;
    end;

    AdoDsClose(dsAux);
    ItsDsNext(dsBaja);
  end;

  ItsDsClose(dsBaja);
end;

{Comparo registro campo por campo y si existe el campo lo grabo en la tabla local.
 Tomo como modelo de estructura la tabla local que se abren por ADO}
Procedure Alta(Conn; TableName:String; Clave:String; IDClave; Metodo:String; var Tipo:String);
begin

  try

  Tipo := '';
  Campo := '';
  {Cargo en dsAlta los valores de casa central}
  dsAlta := ItsDsOpenTable( TableName , Clave +' = ' + QuotedStr( IDClave ) ,'' );

  {Si la clave del dsAlata no esta vacia}
  if not ItsFlEmpty(dsAlta, Clave) then begin

    {Cargo en dsAux los valores de la sucursal}
    dsAux := AdoDsOpenTable(Conn, TableName , Clave +' = ' + QuotedStr( IDClave ) );
    if (dsAux.RecordCount = 0) or (AdoDsEof(dsAux)) then begin
      AdoDsAppend(dsAux);
      GrabarLog('Alta: ' + TableName +' '+ Clave +' = ' + QuotedStr( IDClave ) );
      Tipo := 'ALTA';
    end;
    else begin
      Tipo := 'MODI';
      Error := '';
      if ItsFlCurValue(dsAlta,'FEC_ULT_ACT') < ItsFlCurValue(dsAux,'FEC_ULT_ACT') then begin
        if Metodo = 'A' then begin
          if ItsFlCurValue(dsAux,'EST_EXP_SUC') = 'P' then begin
            Tipo := '';
            Error := 'Error de sincronizacion: casa central ' +
                     FormatDateTime('dd/mm/yyyy hh:mm:ss',ItsFlCurValue(dsAlta,'FEC_ULT_ACT')) + ' y sucursal ' +
                     FormatDateTime('dd/mm/yyyy hh:mm:ss',ItsFlCurValue(dsAux,'FEC_ULT_ACT'));
          end;
          if Pos(ItsFlCurValue(dsAux,'EST_EXP_SUC'), 'AETV') > 0 then
            Tipo := '';
        end;
      end
      else if ItsFlCurValue(dsAlta,'FEC_ULT_ACT') = ItsFlCurValue(dsAux,'FEC_ULT_ACT') then begin
        Tipo := '';
      end
      else begin
        if Metodo = 'A' then begin
          if Pos(ItsFlCurValue(dsAux,'EST_EXP_SUC'), 'AETV') > 0 then
            Error := 'Error de sincronizacion: casa central ' +
                     FormatDateTime('dd/mm/yyyy hh:mm:ss',ItsFlCurValue(dsAlta,'FEC_ULT_ACT')) + ' y sucursal ' +
                     FormatDateTime('dd/mm/yyyy hh:mm:ss',ItsFlCurValue(dsAux,'FEC_ULT_ACT'));
        end;
      end;
      if (Tipo = 'MODI') or (Error <> '') then
        GrabarLog('Modificación: ' + TableName +' '+ Clave +' = ' + QuotedStr( IDClave ) );
      if Error <> '' then
        GrabarLog(Error);
    end;

    if (Tipo = 'ALTA') or (Tipo = 'MODI') then begin
      {Grabo los valores del ds de casa central en el ds de la sucursal }
      for I := 0 to dsAux.Fields.Count - 1 do begin
        Campo := ItsADOFieldNameByIndex(dsAux, I);
        ItsWriteln(Campo) ;
        {Chequeo que exista el campo en la tabla local}
        if dsAlta.FindField( Campo ) then begin
          if Campo = 'EST_EXP_SUC' then
            AdoFlWCurValue(dsAux, Campo, 'P' )
          else begin
            {Grabo el valor si es ( String o Boolean) o
                              (no esta vacio y no es Imagen) }
            if ( (AdoEsString(dsAux, Campo)) or (AdoEsBoolean(dsAux, Campo)) ) or
               ( (not ItsFlEmpty(dsAlta,Campo)) and (not AdoEsImagen(dsAux,Campo)) ) then
              AdoFlWCurValue(dsAux, Campo, ItsFlCurValue(dsAlta,Campo) )
            else if Tipo = 'MODI' then begin
              if (not AdoEsImagen(dsAux,Campo)) then
                AdoFlWCurValue(dsAux, Campo, Null );
            end;
          end;
        end;
      end;
      AdoDsPost(dsAux);
    end;

    AdoDsClose(dsAux);
    ItsDsClose(dsAlta);
  end;
  except
    Raise('Error en rutina Alta: ' + TableName + ' '+ Campo + ' '+ LastExceptionMessage + '   ' + ItsGetErrorResultText);
  end;
end;

{Consulto si la clase tiene Detalle}
Procedure Detalle(Conn; TableName:String; Clave:String; IDClave);
begin
  try
  TablaDetalle := '';
  Campo := '';
  dsDetalle := ItsDsOpenQuery('select FK_ITRIS_CLASSES, ATTFK_ITRIS_ATTRIBUTES2 ' +
                              'from ITRIS_ATTRIBUTES ' +
                              'where LOGICTYPE = ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );

  {Si existen detalles doy de baja y alta cada uno de los detalles}
  ItsDsFirst(dsDetalle);
  while not ItsDsEof(dsDetalle) do begin

    TablaDetalle := TablaPadre( ItsFlCurValue(dsDetalle,'FK_ITRIS_CLASSES'));
    ClaveDetalle := ItsFlCurValue(dsDetalle,'ATTFK_ITRIS_ATTRIBUTES2');
    ExtraerFin(ClaveDetalle,';');

    ItsWriteLn(TablaDetalle);

    {Valido que la clase sea una tabla y no una consulta}
    if (Es_Tabla(TablaDetalle) = True)  then begin

      {ID Clave del detalle y valor por defecto}
      IDClaveDetalle := ItsExecuteFlQuery('select CLAKEYFIELD from ITRIS_CLASSES ' +
                                        'where CLANAME = ' + QuotedStr(TablaDetalle) );
      ValorDefecto := ItsExecuteFlQuery('select ATTDEFVALUE from ITRIS_ATTRIBUTES ' +
                                        'where MK_ITRIS_CLASSES = ' + QuotedStr(TablaDetalle) +
                                        ' and ATTNAME = ' + QuotedStr(IDClaveDetalle) );

      {DS con los detalles}
      dsAlta := ItsDsOpenQuery( 'select * from '+ TablaDetalle +
                                ' where ' + ClaveDetalle + ' = ' + QuotedStr( IDClave ) +
                                ' order by ' + ClaveDetalle ) ;

      {Valido el ultimo ID de la clase detalle}
      if UpperCase(ValorDefecto) = 'ITSNEXTVALUE' then begin
        dsUltimoID := AdoDsOpenQuery(Conn, 'select isnull( max(' + IDClaveDetalle + '), 0) AS ' + IDClaveDetalle + ' from '+ TablaDetalle );
        if dsUltimoID.RecordCount > 0 then
          UltimoID := AdoFlCurValue(dsUltimoID, IDClaveDetalle)
        else
          UltimoID := 0;
        AdoDsClose(dsUltimoID);
      end;

      AltaDetalle := TRUE;

      {Alta de los detalles}
      if AltaDetalle = True then begin
        ItsDsFirst(dsAlta);
        while not ItsDsEof(dsAlta) do begin

          {Baja del detalle}
          dsAux := AdoDsOpenTable(Conn, TablaDetalle , ClaveDetalle + ' = ' + QuotedStr( IDClave ) );
          if dsAux.RecordCount > 0 then begin
            AdoDSFirst(dsAux);
            while not AdoDsEof(dsAux) do begin
              AdoDsDelete(dsAux);
            end;
          end;

          {Alta de detalles}
          Campo := '';
          while not ItsDsEof(dsAlta) do begin
            AdoDsAppend(dsAux);                                                                              
            for I := 0 to dsAux.Fields.Count - 1 do begin

              {Nombre del campo}
              Campo := ItsADOFieldNameByIndex(dsAux, I);

              {Calculo y guardo el nuevo IDD}
              {Es aplicable a cualquier clase que se quiera exportar}
              if (UpperCase(ValorDefecto) = 'ITSNEXTVALUE') and (Campo = IDClaveDetalle) then begin
                NuevoIDD := IDNextValue(Conn,TablaDetalle, IDClaveDetalle, UltimoID);
                AdoFlWCurValue(dsAux, Campo, NuevoIDD );
              end;
              else begin

                {Chequeo que exista el campo en la tabla local}
                if dsAlta.FindField( Campo ) then begin
                  if Campo = 'EST_EXP_SUC' then
                    AdoFlWCurValue(dsAux, Campo, 'P' )
                  else
                    {Grabo el valor si es ( String o Boolean) o (no esta vacio y no es Imagen) }
                    if ( (AdoEsString(dsAux, Campo)) or (AdoEsBoolean(dsAux, Campo)) ) or
                       ( (not ItsFlEmpty(dsAlta,Campo)) and (not AdoEsImagen(dsAux,Campo)) ) then
                      AdoFlWCurValue(dsAux, Campo, ItsFlCurValue(dsAlta,Campo) );
                end;

              end;
            end;
            AdoDsPost(dsAux);

            ItsDsNext(dsAlta);
          end;
          AdoDsClose(dsAux);
        end;
      end;
      ItsDsClose(dsAlta);
    end;
    ItsDsNext(dsDetalle);

  end;
  ItsDsClose(dsDetalle);
  except
    Raise('Error en rutina Alta Detalle: ' + TablaDetalle + ' '+ Campo + ' '+ LastExceptionMessage + '   ' + ItsGetErrorResultText);
  end;
end;

Procedure Exportar(Conn; TableName:String; CondFiltro:String; Clave:String; CondiBaja:String; TieneDetalle:Boolean; var ActualizaCache:Boolean; Metodo: String);
begin
  {Baja por auditoria}
  Baja( Conn, TableName, Clave, CondiBaja, ActualizaCache);

  {Cargo dataset con los registros a exportar}
  dsMaestro := ItsDsOpenQuery('select ' + Clave + ' from '+ TableName +' where ' + CondFiltro );

  if dsMaestro.RecordCount > 0 then begin
    GrabarLog('Registros: ' + TableName + ' = ' + IntToStr(dsMaestro.RecordCount));
    ActualizaCache := True;
  end;

  {Actualizo registro por registro de cada uno de los registros del dsMaestro}
  ItsDsFirst(dsMaestro);
  while not ItsDsEof(dsMaestro) do begin

    IDClave := ItsFlCurValue( dsMaestro, Clave) ;
    ItsWriteLn( IDClave );
    Tipo := '';

    {INICIO Transaccion}
    ItsADOConnBeginTrans(Conn);
    try
      Alta( Conn, TableName, Clave, IDClave, Metodo, Tipo);
      if (TieneDetalle = True) and ((Tipo = 'ALTA') or (Tipo = 'MODI')) then
        Detalle( Conn, TableName, Clave, IDClave );
      ItsADOConnCommitTrans(Conn);
    except
      GrabarLog('  Error en Transaccion  ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
      ItsADOConnRollbackTrans(Conn);
      Raise(LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;
    {FIN Transaccion}

    ItsDsNext(dsMaestro);
  end;
  ItsDsClose(dsMaestro);
end;

Procedure ActualizoCacheClaseADO(Conn; TableName:String);
begin
  SQL := 'update ITRIS_LOGCACHED set CLALASTUPDATE = getdate() ' +
         'from ITRIS_LOGCACHED L ' +
         'where L.CLANAME = ' + QuotedStr(TableName);
  AdoExecuteCommand(Conn, SQL);
  SQL := 'update ITRIS_LOGCACHED set CLALASTUPDATE = getdate() ' +
         'from ITRIS_LOGCACHED L ' +
         'join ITRIS_ATTRIBUTES A on LOGICTYPE = ''D'' and A.FK_ITRIS_CLASSES = L.CLANAME ' +
         'join ITRIS_CLASSES C on C.CLANAME = L.CLANAME and C.CLASSTYPE = ''P'' ' +
         'where A.MK_ITRIS_CLASSES = ' + QuotedStr(TableName);
  AdoExecuteCommand(Conn, SQL);
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////// IMPORTACION DE CLASES DESDE LAS SUCURSALES HACIA CASA CENTRAL /////////////////////////
//////////////////////               SE LEE POR ADO Y DE GRABA POR ITS               /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

Function CamposClase(Conn; Clave:String; TableName:String):String
begin
  {Cargo en dsCampos los nombres de los campos de la clase}
  dsCampos := AdoDsOpenQuery(Conn, 'select ATTNAME ' +
                                   'from ITRIS_ATTRIBUTES ' +
                                   'where TYPE <> ''L'' and TYPE <> ''A'' and  ' +
                                   '      LOGICTYPE <> ''K'' and LOGICTYPE <> ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );
  Campos := '';
  if dsCampos.RecordCount > 0 then begin
    AdoDsFirst(dsCampos);
    while not AdoDsEof(dsCampos) do begin
      Campo := AdoFlCurValue(dsCampos, 'ATTNAME' );
      {Pongo como primera variable la clave de la clase}
      if Campo = Clave then
        Campos  := Clave +','+ Campos
      else
        Campos  := Campos  + Campo + ',' ;

      AdoDsNext(dsCampos);
    end;
    AdoDsClose(dsCampos);
  end;
  Result := TrimLeft(Copy(Campos , 1, Length(Campos)-1)) ;
end;

Function ValoresClase(var SqlResRisSuc:String; Conn; dsDatos; Clave:String; TableName:String ):String
begin
  {Cargo en dsCampos los nombres de los campos de la clase}
  dsCampos := AdoDsOpenQuery(Conn, 'select ATTNAME, TYPE ' +
                                   'from ITRIS_ATTRIBUTES ' +
                                   'where TYPE <> ''L'' and TYPE <> ''A'' and ' +
                                   '      LOGICTYPE <> ''K'' and LOGICTYPE <> ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );
  Valores := '';
  if dsCampos.RecordCount > 0 then begin
    AdoDsFirst(dsCampos);
    while not AdoDsEof(dsCampos) do begin
      Campo := AdoFlCurValue(dsCampos, 'ATTNAME' );
      Valor := AdoFlAsSqlStr(dsDatos, Campo);

      {Reemplazo " por +char(34)+ y Reemplazo , por +char(44)+ }
      {Si el tipo de campo es String o Memo}
      TipoCampo := AdoFlCurValue(dsCampos, 'TYPE');
      if ( TipoCampo = 'V') or ( TipoCampo = 'M') then begin
        Valor := ItsStringReplace(Valor, '"', QuotedStr('+char(34)+'));
        Valor := ItsStringReplace(Valor, ',', QuotedStr('+char(44)+'));
        Valor := ItsStringReplace(Valor, '`', QuotedStr('+char(32)+'));
      end;

      {Si es ERP_DET_COM y el campo es COM_STO o RES_STO, debe importarse en false}
      if (TableName = 'ERP_DET_COM') and ( (Campo = 'COM_STO') or (Campo = 'RES_STO') ) then
        Valor := '0';

      {Si existe en la clase el campo FEC_ULT_ACT esto implica que la clase tambien es exportable}
      {Entonces pongo la fecha de ultima actualizacion la fecha y hora del servidor en este momento}
      if Campo = 'FEC_ULT_ACT' then begin
        HoraActual := ItsExecuteFLQuery('select getdate() from ERP_PARAMETROS');
        Valor := QuotedStr(FormatDateTime('yyyy/mm/dd hh:mm:ss', HoraActual));
      end;

      {Pongo como estado en blanco a los registros importados de la sucursal}
      if Campo = 'EST_EXP_SUC' then
        Valor := ''' ''';

      {Pongo como primer valor la clave de la clase}
      if Campo = Clave then
        Valores := Valor + ',' + Valores
      else
        Valores := Valores + Valor + ',' ;

      AdoDsNext(dsCampos);
    end;
  end;
  AdoDsClose(dsCampos);

  Result := TrimLeft(Copy(Valores, 1, Length(Valores)-1)) ;
end;

Function CampoValor(Campos:String; Valores:String):String
begin
  Campo := '';
  Valor:= '';
  CampoValor := '' ;
  AsignaCampo := False; {no se asigna el primer campo porque es el ID}
  while Length(Campos) > 0 do begin
    ExtraerSig(Campo,Campos,',') ;
    ExtraerSig(Valor,Valores,',') ;
    if AsignaCampo = True then
      CampoValor := CampoValor + Campo + ' = ' + Valor + ', '
    else
      AsignaCampo := True;
  end;
  CampoValor := TrimLeft(Copy(CampoValor, 1, Length(CampoValor)-2)) ;

  Result := CampoValor ;
end;

function RecalculaIDD(TablaName:String):Boolean;
begin
  {Si la clase esta en ERP_CLA_SUC, esta habilitada y Recalcula IDD => Recalcula }
  {Si la clase NO ESTA en ERP_CLA_SUC => Recalcula }

  dsRecalcula := ItsDsOpenQuery(
    'select RECALCULA_IDD from ERP_CLA_SUC '+
    'where ID = ' + QuotedStr(TablaName) + ' and HABILITADO = 1');

  if (dsRecalcula.RecordCount = 0) then
    Result := True
  else if (ItsFlCurValue(dsRecalcula, 'RECALCULA_IDD') = True) then
    Result := True
  else
    Result := False;

  ItsDsClose(dsRecalcula);
end;

Procedure ArmarSQL(var Sql:String; var SqlResRisSuc:String; TableName:String; Campos:String; Valores:String; Clave:String; ValorDefecto:String;
                   Es_Detalle:Boolean; ExisteReg:Boolean; ValorClave, EncaCondicion: String);
begin

  if ExisteReg = True then begin
    if EncaCondicion = '' then
      Sql := Sql +
         ' update ' + TableName + chr(13)+chr(10) +
         ' set ' + CampoValor(Campos, Valores) + chr(13)+chr(10)+
         ' where ' + Clave + ' = ' + QuotedStr(ValorClave) + chr(13)+chr(10) ;
    else
      Sql := Sql +
         ' update ' + TableName + chr(13)+chr(10) +
         ' set ' + CampoValor(Campos, Valores) + chr(13)+chr(10)+
         ' where ' + EncaCondicion + chr(13)+chr(10) ;
  end;
  else begin
    if (UpperCase(ValorDefecto) = 'ITSNEXTVALUE') and (RecalculaIDD(TableName)) then begin
      IdsAttribute := TableName +';'+ Clave ;
      Sql := Sql +
           'if (select count(*) from ITRIS_IDSVALUES where IDS_ATTRIBUTE = ' + QuotedStr(IdsAttribute) + ' ) = 0 begin ' +
           '  set @IDD = ( select isnull(max(' + Clave + '),0) from ' + TableName + ' ) ' +
           '  insert into ITRIS_IDSVALUES (IDS_ATTRIBUTE, IDS_VALUE, IDS_STEPBY) ' +
           '  values (' + QuotedStr(IdsAttribute) +',@IDD,' + QuotedStr('1') +') ' +
         '  if @@ERROR <> 0 begin     rollback     return    end ' +
           'end ' + chr(13)+chr(10) +

           'update ITRIS_IDSVALUES set IDS_VALUE = IDS_VALUE + 1 where IDS_ATTRIBUTE = ' + QuotedStr(IdsAttribute) + chr(13)+chr(10) +
         '   set @IDD = (select IDS_VALUE from ITRIS_IDSVALUES where IDS_ATTRIBUTE = ' + QuotedStr(IdsAttribute) + ' ) ' + chr(13)+chr(10) +
         'if @@ERROR <> 0 begin     rollback     return    end ' + chr(13)+chr(10) ;

      { Como la clave es 'ITSNEXTVALUE' y es el primer campo de la variable Campos, }
      { reemplazo el primer valor de la variable Valores por @IDD }

      Valores := '@IDD,' + ExtraerFin( Valores,',');

    end;

    Sql := Sql + SqlResRisSuc +
         ' insert into ' + TableName +
         ' ( ' + Campos + ' ) ' + chr(13)+chr(10) +
         'values ' +
         ' ( ' + Valores + ' ) ' + chr(13)+chr(10) ;
  end;

  {Pregunto si huvo error}
  Sql := Sql +
       ' if @@ERROR <> 0 begin ' +
       '    rollback ' +
       '    return   ' +
       ' end ' + chr(13)+chr(10) ;

end;

Procedure BorroDetalle(var Sql:String; TablaDetalle:String; ClaveDetalle:String; EncaValorClave);
begin
  Sql := Sql +
         'delete from ' + TablaDetalle +
         ' where ' + ClaveDetalle + ' = ' + QuotedStr(EncaValorClave) + chr(13)+chr(10) ;
end;

Function CargaDetalle(TablaDetalle: String; dsDatosDeta): Boolean
begin
  Cantidad := 0;
  if TablaDetalle = 'ERP_IMP_VEN' then
    Cantidad := ItsExecuteFlQuery('select count(*) from '+ TablaDetalle +
                                  ' where FK_ERP_DEB_VEN = ' + AdoFlAsSqlStr(dsDatosDeta, 'FK_ERP_DEB_VEN') + ' and ' +
                                  '       FK_ERP_CRE_VEN = ' + AdoFlAsSqlStr(dsDatosDeta, 'FK_ERP_CRE_VEN') + ' and ' +
                                  '                  VTO = ' + AdoFlAsSqlStr(dsDatosDeta, 'VTO'));

  if TablaDetalle = 'ERP_IMP_COM' then
    Cantidad := ItsExecuteFlQuery('select count(*) from '+ TablaDetalle +
                                  ' where FK_ERP_DEB_COM = ' + AdoFlAsSqlStr(dsDatosDeta, 'FK_ERP_DEB_COM') + ' and ' +
                                  '       FK_ERP_CRE_COM = ' + AdoFlAsSqlStr(dsDatosDeta, 'FK_ERP_CRE_COM') + ' and ' +
                                  '                  VTO = ' + AdoFlAsSqlStr(dsDatosDeta, 'VTO'));

  if Cantidad > 0 then
    Result := FALSE
  else
    Result := TRUE ;
end;

Function ExisteReg( TableName:String; Clave:String; ValorClave; ValorDefecto:String;
                    ActDatos:Boolean; EncaCondicion: String; var FecUltAct: TDateTime; ExisteFecUltAct:Boolean ):Boolean
begin
  if EncaCondicion <> '' then begin
    {Verifico si existe registro segun condicion}
    if ExisteFecUltAct = False then begin
      dsAux := ItsDsOpenQuery('select ' + Clave + ' from ' + TableName + ' where ' + EncaCondicion );
      FecUltAct := null;
      Result := (dsAux.RecordCount > 0);
      ItsDsClose(dsAux);
      Exit;
    end;
    else begin
      dsAux := ItsDsOpenQuery('select top 1 FEC_ULT_ACT from ' + TableName + ' where ' + EncaCondicion );
      FecUltAct := ItsFlCurValue(dsAux,'FEC_ULT_ACT');
      Result := (dsAux.RecordCount > 0);
      ItsDsClose(dsAux);
      Exit;
    end;
  end;

  {Para el caso de los detalles con  'ITSNEXTVALUE' }
  if ( UpperCase(ValorDefecto) = 'ITSNEXTVALUE' ) and ( ActDatos = False )  then begin
    Result := FALSE ;
    exit;
  end;

  {Verifico si existe el registro}
  if ExisteFecUltAct = False then begin
    dsAux := ItsDsOpenQuery('select top 1 ' + Clave + ' from '+ TableName + ' where ' + Clave + ' = ' + QuotedStr(ValorClave) );
    FecUltAct := null;
  end
  else begin
    dsAux := ItsDsOpenQuery('select top 1 FEC_ULT_ACT from '+ TableName + ' where ' + Clave + ' = ' + QuotedStr(ValorClave) );
    FecUltAct := ItsFlCurValue(dsAux,'FEC_ULT_ACT');
  end;
  Result := (dsAux.RecordCount > 0);
  ItsDsClose(dsAux);
end;

Procedure ClaveDefecto(var Clave, ValorDefecto:String; dsAux; TableName:String );
begin
  AdoDsFirst(dsAux);
  if not AdoDsEof(dsAux) then begin
    Clave := ItsExecuteFlQuery('select CLAKEYFIELD from ITRIS_CLASSES ' +
                               'where CLANAME = ' + QuotedStr(TableName) );
    ValorDefecto := ItsExecuteFlQuery('select ATTDEFVALUE from ITRIS_ATTRIBUTES ' +
                                      'where MK_ITRIS_CLASSES = ' + QuotedStr(TableName) +
                                      ' and ATTNAME = ' + QuotedStr(Clave) );
  end;
end;

Procedure VerificoTrans( dsAux; TableName:String; Clave:String; ValorClave; SeEjecuto:Boolean; DebeExistir:Boolean; CondicionWhere:String);
begin
  if SeEjecuto = True then begin
    {Verifico si existe el registro}
    if CondicionWhere = '' then
      Cantidad := ItsExecuteFlQuery('select count(*) from '+ TableName +
                                    ' where ' + Clave + ' = ' + QuotedStr(ValorClave) )
    else
      Cantidad := ItsExecuteFlQuery('select count(*) from '+ TableName +
                                    ' where ' + CondicionWhere );
    if ((Cantidad > 0) and (DebeExistir = TRUE)) or ((Cantidad = 0) and (DebeExistir = FALSE)) then
      {Grabo el registro en estado Procesado}
      AdoFlWCurValue(dsAux, 'EST_EXP_SUC', 'P' );
    else begin
      {Verifico si hay conexion a la base de datos}
      Parametros := ItsExecuteFlQuery('select count(*) from ERP_PARAMETROS' );
      if Parametros > 0 then begin
        {Grabo el registro en estado Error de Validación}
        AdoFlWCurValue(dsAux, 'EST_EXP_SUC', 'V' );
        GrabarLog('  Error de validación');
      end;
      else begin
        {Grabo el registro en estado T Error en la transmisión}
        AdoFlWCurValue(dsAux, 'EST_EXP_SUC', 'T' );
        GrabarLog('  Error de transmisión');
      end;
    end;
  end;
end;

Procedure AnulacionFrm(Conn; dsImportar; TableName:String; EncaClave:String; EncaValorClave );
begin
  GrabarLog('Clase: ' + TableName +' '+ EncaClave +' = '+ QuotedStr(EncaValorClave) );
  try
    frmAnulacion := ItsFrmCreate(Tablename, False);
    ItsFrmOpen(frmAnulacion);
    frmAnulacion.Visible := False;

    dsAnulacion := ItsFrmGetDataSet(frmAnulacion);

    Existe := ItsExecuteFlQuery('select count(*) from ' + TableName +
                                ' where ' + EncaClave + ' = ' + QuotedStr(EncaValorClave) ) > 0 ;
    if Existe = True then
      {Grabo el registro en estado Procesado}
      AdoFlWCurValue(dsImportar, 'EST_EXP_SUC', 'P' )
    else begin

      ItsFrmAppend(frmAnulacion);

      ItsFlWCurValue(dsAnulacion,'FK_ERP_T_COM_COM', AdoFlCurValue(dsImportar, 'FK_ERP_T_COM_COM'));
      ItsFlWCurValue(dsAnulacion,'FK_ERP_COM_COM', AdoFlCurValue(dsImportar, 'FK_ERP_COM_COM'));
      ItsFlWCurValue(dsAnulacion,'FECHA', AdoFlCurValue(dsImportar, 'FECHA'));
      ItsFlWCurValue(dsAnulacion,'FK_ERP_T_COM_TES', AdoFlCurValue(dsImportar, 'FK_ERP_T_COM_TES'));
      ItsFlWCurValue(dsAnulacion,'FK_ERP_TALONARIOS', AdoFlCurValue(dsImportar, 'FK_ERP_TALONARIOS'));
      ItsFlWCurValue(dsAnulacion,'NUM_COM', AdoFlCurValue(dsImportar, 'NUM_COM'));
      ItsFlWCurValue(dsAnulacion,'EST_EXP_SUC', '');
      ItsDsPost(dsAnulacion);
      ItsFrmAccept(frmAnulacion);

      {Verifico transaccion}
      VerificoTrans(dsImportar, TableName, EncaClave, EncaValorClave, True, True, '');

    end;
  except
    GrabarLog('Error al grabar: ' + LastExceptionMessage + ' ' + ItsGetErrorResultText );
    try
      dsAnulacion.Cancel;
    except
    end;
  end;

end;

function ExisteFecUltAct(dsImportar);
begin
  if dsImportar.FindField( 'FEC_ULT_ACT' ) then
    Result := True
  else
    Result := False;
end;

Procedure Importar(Conn; TableName:String; Filtro:String; ActDatos:Boolean; var ActualizaCache:Boolean; Metodo: string);
begin
  EncaCampos  := '';
  EncaClave := '';
  EncaValorDefecto := '';
  EncaCondicion := '';

  dsImportar := AdoDsOpenQuery(Conn, 'select TOP 20 * from ' + TableName + ' with(READCOMMITTED) ' +
                                     ' where EST_EXP_SUC in (''A'',''E'',''T'',''V'')' +
                                     ' and ' + Filtro +
                                     ' order by EST_EXP_SUC desc' );

  GrabarLog('Registros: ' + TableName + ' = ' + IntToStr(dsImportar.RecordCount));

  if dsImportar.RecordCount > 0 then begin

    ActualizaCache := True;
    ExisteFecUltAct := ExisteFecUltAct(dsImportar);

//    GrabarLog('Registros: ' + TableName + ' = ' + IntToStr(dsImportar.RecordCount));

    {Busco la CLAVE y el valor por DEFECTO de la clase}
    ClaveDefecto(EncaClave, EncaValorDefecto, dsImportar, TableName );

    {Cargo en variables los Campos y los Valores por cada transaccion}
    AdoDsFirst(dsImportar);
    while not AdoDsEof(dsImportar) do begin

      EncaValorClave := AdoFlCurValue(dsImportar, EncaClave );

      {Clases que se importan segun condicion y por su clave unica}
      if TableName = 'ERP_IMP_VEN' then begin
        EncaCondicion := 'FK_ERP_CRE_VEN = ' + AdoFlAsSqlStr(dsImportar, 'FK_ERP_CRE_VEN') + ' and ' +
                         'FK_ERP_DEB_VEN = ' + AdoFlAsSqlStr(dsImportar, 'FK_ERP_DEB_VEN') + ' and ' +
                         '           VTO = ' + AdoFlAsSqlStr(dsImportar, 'VTO');
      end;
      if TableName = 'ERP_IMP_COM' then begin
        EncaCondicion := 'FK_ERP_CRE_COM = ' + AdoFlAsSqlStr(dsImportar, 'FK_ERP_CRE_COM') + ' and ' +
                         'FK_ERP_DEB_COM = ' + AdoFlAsSqlStr(dsImportar, 'FK_ERP_DEB_COM') + ' and ' +                                 
                         '           VTO = ' + AdoFlAsSqlStr(dsImportar, 'VTO');
      end;
      if TableName = 'ERP_IMP_CUO_CRE' then begin
        EncaCondicion := 'FK_ERP_COM_VEN = ' + QuotedStr( AdoFlCurValue(dsImportar,'FK_ERP_COM_VEN') ) + ' and ' +
                         'FK_ERP_CUO_CRE = ' + QuotedStr( AdoFlCurValue(dsImportar,'FK_ERP_CUO_CRE') ) + ' and ' +
                         'TIPO = ' + QuotedStr( AdoFlCurValue(dsImportar,'TIPO') ) + ' and ' +
                         'IMPORTE = ' + FloatToStr( AdoFlCurValue(dsImportar,'IMPORTE') );
      end;

      Sql := 'declare @IDD int ' + chr(13)+chr(10);

      ImportaDatos := True;
      FecUltAct := Now;
      ExisteReg := ExisteReg(TableName, EncaClave, EncaValorClave, EncaValorDefecto, ActDatos, EncaCondicion, FecUltAct, ExisteFecUltAct);

      if (ExisteReg = True) and (ActDatos = False) then begin
        {Grabo el registro en estado Procesado}
        AdoFlWCurValue(dsImportar, 'EST_EXP_SUC', 'P' );
        ImportaDatos := False;
      end;
      else begin
        if EncaCondicion = '' then
          GrabarLog('Clase: ' + TableName +' '+ EncaClave +' = '+ QuotedStr(EncaValorClave) )
        else
          GrabarLog('Clase: ' + TableName +' '+ EncaCondicion );

        if (ExisteReg = True) and (ExisteFecUltAct = True) then begin        
          {ACA NO SERIA AdoFlCurValue()  !!!!!! ???????}
          if (FecUltAct > ItsFlCurValue(dsImportar,'FEC_ULT_ACT')) and (Metodo = 'A') then begin
{} {} {falta las horas}
            GrabarLog('Error de sincronizacion');
            ImportaDatos := False;
          end;
        end;
      end;

      if ImportaDatos = True then begin
        {Grabo el registro en estado En proceso}
        AdoFlWCurValue(dsImportar, 'EST_EXP_SUC', 'E' );

        if EncaCampos = '' then
          EncaCampos := CamposClase(Conn, EncaClave, TableName);

        SqlResRisSuc := '';
        EncaValores := ValoresClase(SqlResRisSuc, Conn, dsImportar, EncaClave, TableName);
        ItsWriteLn(EncaCampos);
        ItsWriteLn(EncaValores);
        ArmarSQL(Sql, SqlResRisSuc, TableName, EncaCampos, EncaValores, EncaClave, EncaValorDefecto, False, ExisteReg, EncaValorClave, EncaCondicion);

        {Busco detalles en la clase}
        dsDetalle := AdoDsOpenQuery(Conn, 'select FK_ITRIS_CLASSES, ATTFK_ITRIS_ATTRIBUTES2 ' +
                                          'from ITRIS_ATTRIBUTES ' +
                                          'where LOGICTYPE = ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );
        {Armo SQL con los detalles de la clase}
        if dsDetalle.RecordCount > 0 then begin
          AdoDsFirst(dsDetalle);
          while not AdoDsEof(dsDetalle) do begin
            TablaDetalle := TablaPadre( AdoFlCurValue(dsDetalle,'FK_ITRIS_CLASSES') );
            ClaveDetalle := AdoFlCurValue(dsDetalle,'ATTFK_ITRIS_ATTRIBUTES2');
            ExtraerFin(ClaveDetalle,';');

            if Es_Tabla(TablaDetalle) = True then begin

              DetaCampos  := '';
              DetaClave := '';
              DetaValorDefecto := '';

              dsDatosDeta := AdoDsOpenQuery(Conn, 'select * from '+ TablaDetalle +
                                                  ' where ' + ClaveDetalle + ' = ' + QuotedStr(EncaValorClave) );

              {Borro los datos del detalles para que se actualicen nuevamente}
              if ActDatos = True then
                BorroDetalle(Sql, TablaDetalle, ClaveDetalle, EncaValorClave);

              {Busco la CLAVE y el valor por DEFECTO de la clase Detalle}
              ClaveDefecto(DetaClave, DetaValorDefecto, dsDatosDeta, TablaDetalle );

              {Cargo en variables los Campos y los Valores del detalle}
              if dsDatosDeta.RecordCount > 0 then begin
                AdoDsFirst(dsDatosDeta);
                while not AdoDsEof(dsDatosDeta) do begin

                  if DetaCampos = '' then
                    DetaCampos := CamposClase(Conn, DetaClave, TablaDetalle);

                  {Hay detalles que se pueden importar por separado y deben saltearse}
                  if CargaDetalle(TablaDetalle, dsDatosDeta) then begin
                    SqlResRisSuc := '';
                    DetaValores := ValoresClase(SqlResRisSuc, Conn, dsDatosDeta, DetaClave, TablaDetalle);
                    ArmarSQL(Sql, SqlResRisSuc, TablaDetalle, DetaCampos, DetaValores, DetaClave, DetaValorDefecto, True, False, '', '');
                  end;
                  AdoDsNext(dsDatosDeta);
                end;
              end;
              AdoDsClose(dsDatosDeta);

            end;
            AdoDsNext(dsDetalle);

          end;
        end;
        AdoDsClose(dsDetalle);   

        Sql := 'BEGIN TRANSACTION' + chr(13)+chr(10) + Sql + 'COMMIT';

        ItsWriteLn( Sql ) ;

        {Esto genera un archivo por cada transaccion con su script correspondiente}
//        GrabarSQL( EncaValorClave, Sql );

        {Ejecuto script}
        try
          ItsExecuteCommand( Sql ) ;
          SeEjecuto := True;
          {Si esta todo OK borro el script}
//          BorrarSQL( EncaValorClave );
        except
          GrabarLog('  Error en Script  ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
          SeEjecuto := False;
        end;

        {Verifico transaccion}
        VerificoTrans(dsImportar, TableName, EncaClave, EncaValorClave, SeEjecuto, True, EncaCondicion);

      end;
      AdoDsNext(dsImportar);
    end;
  end;
  AdoDsClose(dsImportar);
end;

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////  Borro comprobantes borrados en la sucursal //////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

Procedure BorroComprobantes(Conn, Frecuencia);
begin
  GrabarLog('Inicio borrado de comprobantes');

  {Verifico que las clases a borrar se centralice en Casa Central}
  BorraCompCompra := ItsExecuteFlQuery('select count(*) from ERP_CLA_SUC where ID = ' + QuotedStr( 'ERP_COM_COM' ) +
    ' and METODO in (''I'',''A'') and HABILITADO = 1 and FRECUENCIA = ' + QuotedStr(Frecuencia) ) > 0 ;

  BorraImpVenta := ItsExecuteFlQuery('select count(*) from ERP_CLA_SUC where ID = ' + QuotedStr( 'ERP_IMP_VEN' ) +
    ' and METODO in (''I'',''A'') and HABILITADO = 1 and FRECUENCIA = ' + QuotedStr(Frecuencia) ) > 0 ;

  BorraImpCompra := ItsExecuteFlQuery('select count(*) from ERP_CLA_SUC where ID = ' + QuotedStr( 'ERP_IMP_COM' ) +
    ' and METODO in (''I'',''A'') and HABILITADO = 1 and FRECUENCIA = ' + QuotedStr(Frecuencia) ) > 0 ;

  dsComBorrar := AdoDsOpenQuery(Conn, 'select * from ERP_COM_BOR_SUC with(READCOMMITTED)' +
                                      ' where EST_EXP_SUC in (''A'',''E'',''T'',''V'')' +
                                      ' order by ID' );

  {Cargo en variables los Campos y los Valores por cada transaccion}
  if dsComBorrar.RecordCount > 0 then begin
    AdoDsFirst(dsComBorrar);
    while not AdoDsEof(dsComBorrar) do begin

      {Cargo en variables los datos del comprobante a borrar}
      TableName := AdoFlCurValue(dsComBorrar,'CLASSNAME') ;

      Condicion := '';

      if (TableName = 'ERP_COM_COM') and (BorraCompCompra = True) then begin
        EncaValorClave := AdoFlCurValue(dsComBorrar,'FK_ERP_COM_COM') ;
        Condicion := 'ID = ' + QuotedStr( EncaValorClave ) ;
      end;
      if (TableName = 'ERP_IMP_VEN') and (BorraImpVenta = True) then begin
        ClaveCRE := AdoFlCurValue(dsComBorrar,'FK_ERP_CRE_VEN') ;
        ClaveDEB := AdoFlCurValue(dsComBorrar,'FK_ERP_DEB_VEN') ;
        Condicion := 'FK_ERP_CRE_VEN = ' + QuotedStr( ClaveCRE ) + ' and ' +
                     'FK_ERP_DEB_VEN = ' + QuotedStr( ClaveDEB ) ;
      end;
      if (TableName = 'ERP_IMP_COM') and (BorraImpCompra = True) then begin
        ClaveCRE := AdoFlCurValue(dsComBorrar,'FK_ERP_CRE_COM') ;
        ClaveDEB := AdoFlCurValue(dsComBorrar,'FK_ERP_DEB_COM') ;
        Condicion := 'FK_ERP_CRE_COM = ' + QuotedStr( ClaveCRE ) + ' and ' +
                     'FK_ERP_DEB_COM = ' + QuotedStr( ClaveDEB ) ;
      end;

      if Condicion = '' then begin
        Can := ItsExecuteFlQuery('select count(*) from ERP_CLA_SUC '+
                 'where ID = ' + QuotedStr( TableName ) + ' and METODO in (''I'',''A'') and HABILITADO = 1');
        if Can = 0 then begin
          {Pongo como procesado el registro para que no se centralice en el futuro por error }
          AdoFlWCurValue(dsComBorrar, 'EST_EXP_SUC', 'P' )
        end;
      end
      else begin

        {Verifico si existe registro segun condicion}
        ExisteReg := ItsExecuteFlQuery('select count(*) from ' + TableName + ' where ' + Condicion ) > 0 ;

        if ExisteReg = False then begin
          {Grabo el registro en estado Procesado}
          AdoFlWCurValue(dsComBorrar, 'EST_EXP_SUC', 'P' );
        end;
        else begin

          {Grabo el registro en estado En proceso}
          AdoFlWCurValue(dsComBorrar, 'EST_EXP_SUC', 'E' );

          GrabarLog('Borro Clase: ' + TableName +' '+ Condicion );

          Sql := 'delete from ' + TableName + ' where ' + Condicion + chr(13)+chr(10) ;

          {Busco detalles en la clase}
          dsDetalle := ItsDsOpenQuery('select FK_ITRIS_CLASSES, ATTFK_ITRIS_ATTRIBUTES2 ' +
                                      'from ITRIS_ATTRIBUTES ' +
                                      'where LOGICTYPE = ''D'' and MK_ITRIS_CLASSES = ' + QuotedStr(TableName) );

          {Armo SQL con los detalles de la clase}
          ItsDsFirst(dsDetalle);
          while not ItsDsEof(dsDetalle) do begin
            TablaDetalle := TablaPadre( ItsFlCurValue(dsDetalle,'FK_ITRIS_CLASSES') );
            ClaveDetalle := ItsFlCurValue(dsDetalle,'ATTFK_ITRIS_ATTRIBUTES2');
            ExtraerFin(ClaveDetalle,';');

            if Es_Tabla(TablaDetalle) = True then begin

              Sql := Sql +
                     'delete from ' + TablaDetalle +
                     ' where ' + ClaveDetalle + ' = ' + QuotedStr(EncaValorClave ) + chr(13)+chr(10) ;

              {Si es debito, la relacion de las imputaciones no esta como detalle}
              if TablaDetalle = 'ERP_IMP_COM' then
                Sql := Sql +
                       'delete from ' + TablaDetalle +
                       ' where FK_ERP_DEB_COM = ' + QuotedStr(EncaValorClave ) + chr(13)+chr(10) ;
            end;

            ItsDsNext(dsDetalle);
          end;
          ItsDsClose(dsDetalle);

          Sql := 'BEGIN TRANSACTION' + chr(13)+chr(10) + Sql + 'COMMIT';

          ItsWriteLn( Sql ) ;

          {Ejecuto script}
          try
            ItsExecuteCommand( Sql ) ;
            SeEjecuto := True;
          except
            GrabarLog('  Error en Script  ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
            SeEjecuto := False;
          end;

          {Verifico transaccion}
          VerificoTrans(dsComBorrar, TableName, '', '', SeEjecuto, False, Condicion);
        end;
      end;

      AdoDsNext(dsComBorrar);
    end;
  end;
  AdoDsClose(dsComBorrar);
  GrabarLog('Fin borrado de comprobantes');
end;

Procedure SaldoCompSuc(Conn; Filtro:String );
begin
  GrabarLog('Inicio generacion de saldos comprometidos');

  {Si son null grabo ''}
  SQL := 'update ERP_DET_COM set FK_ERP_COLORES = ' + QuotedStr('') +
         ' where FK_ERP_COLORES is null ';
  AdoExecuteCommand(Conn, SQL);

  SQL := 'update ERP_DET_COM set FK_ERP_IDENTIFICADORES = ' + QuotedStr('') +
         ' where FK_ERP_IDENTIFICADORES is null ';
  AdoExecuteCommand(Conn, SQL);

  SQL := 'update ERP_DET_COM set FK_ERP_UBICACIONES = ' + QuotedStr('') +
         ' where FK_ERP_UBICACIONES is null ';
  AdoExecuteCommand(Conn, SQL);

  {Inserto articulos que no estan estan en ERP_SAL_COMP_SUC}
  SQL := 'insert into ERP_SAL_COMP_SUC ' +
           '(FK_ERP_ARTICULOS, FK_ERP_COLORES, FK_ERP_IDENTIFICADORES, FK_ERP_UBICACIONES, ' +
           ' FK_ERP_DEPOSITOS, SAL_ING, SAL_EGR, ID, EST_EXP_SUC) ' +
           'select ' +
              'C.FK_ERP_ARTICULOS, ' +
              'C.FK_ERP_COLORES, ' +
              'C.FK_ERP_IDENTIFICADORES, ' +
              'C.FK_ERP_UBICACIONES, ' +
              'C.FK_ERP_DEPOSITOS, ' +
              'C.SAL_ING, ' +
              'C.SAL_EGR, ' +
              'C.FK_ERP_ARTICULOS+' + QuotedStr('_') + '+isnull(C.FK_ERP_COLORES,'+ QuotedStr('') +')+' +
                                      QuotedStr('_') + '+isnull(C.FK_ERP_IDENTIFICADORES,'+ QuotedStr('') +')+' +
                                      QuotedStr('_') + '+isnull(C.FK_ERP_UBICACIONES,'+ QuotedStr('') +')+' +
                                      QuotedStr('_') + '+cast( isnull(C.FK_ERP_DEPOSITOS,0) as varchar) as ID, ' +
              QuotedStr( 'A' ) + ' as EST_EXP_SUC ' +
           'from ERP_SAL_COMP C ' +
              'left join ERP_SAL_COMP_SUC S on S.FK_ERP_ARTICULOS = C.FK_ERP_ARTICULOS and ' +
                                              'S.FK_ERP_COLORES = C.FK_ERP_COLORES and ' +
                                              'S.FK_ERP_IDENTIFICADORES = C.FK_ERP_IDENTIFICADORES and ' +
                                              'S.FK_ERP_UBICACIONES = C.FK_ERP_UBICACIONES and ' +
                                              'S.FK_ERP_DEPOSITOS = C.FK_ERP_DEPOSITOS ' +
           'where S.FK_ERP_ARTICULOS is null ';
  ItsWriteLn(SQL);
  AdoExecuteCommand(Conn, SQL);

  {Actualizo las cantidades que se modificaron en ERP_SAL_COMP_SUC}
  SQL := 'update ERP_SAL_COMP_SUC ' +
         'set SAL_ING = isnull(C.SAL_ING, 0) , SAL_EGR = isnull(C.SAL_EGR, 0) , EST_EXP_SUC = ' + QuotedStr('A') + ' ' +
         'from ERP_SAL_COMP C ' +
         'right join ERP_SAL_COMP_SUC S on S.FK_ERP_ARTICULOS = C.FK_ERP_ARTICULOS and ' +
                                      'S.FK_ERP_COLORES = C.FK_ERP_COLORES and ' +
                                      'S.FK_ERP_IDENTIFICADORES = C.FK_ERP_IDENTIFICADORES and ' +
                                      'S.FK_ERP_UBICACIONES = C.FK_ERP_UBICACIONES and ' +
                                      'S.FK_ERP_DEPOSITOS = C.FK_ERP_DEPOSITOS ' +
         'where isnull(S.SAL_ING,0) <> isnull(C.SAL_ING,0) or isnull(S.SAL_EGR,0) <> isnull(C.SAL_EGR,0) ' ;
  AdoExecuteCommand(Conn, SQL);

  GrabarLog('Fin generacion de saldos comprometidos');
end;

Procedure SaldoDispSuc(Conn; Filtro:String );
begin
  GrabarLog('Inicio generación de saldos disponibles');

  Consulta := '  select cast(D.FK_ERP_SUCURSALES as varchar) + ''_'' + ' +
         '         cast(R.FK_ERP_ARTICULOS as varchar) + ''_'' + ' +
         '         cast(R.FK_ERP_COLORES as varchar) as ID, ' +                                           
         '  D.FK_ERP_SUCURSALES, ' +
         '  R.FK_ERP_ARTICULOS, ' +
         '  R.FK_ERP_COLORES, ' +
         '  isnull(R.SAL_REAL, 0) as SAL_REAL , ' +
         '  0 as SAL_COMP ' +
         '  from ERP_SAl_REAL R ' +
         '  join ERP_DEPOSITOS D on D.ID = R.FK_ERP_DEPOSITOS and D.INF_DIS_SUC = 1 and D.FK_ERP_SUCURSALES = ' + QuotedStr(ErpSucursalUsuarioActivo) +
         ' ' +
         '  union all ' +
         '  select cast(D.FK_ERP_SUCURSALES as varchar) + ''_'' + ' +
         '         cast(C.FK_ERP_ARTICULOS as varchar) + ''_'' + ' +
         '         cast(C.FK_ERP_COLORES as varchar) as ID, ' +
         '  D.FK_ERP_SUCURSALES, ' +
         '  C.FK_ERP_ARTICULOS, ' +
         '  C.FK_ERP_COLORES, ' +
         '  0 as SAL_REAL, ' +
         '  isnull(C.SAL_ING, 0) - isnull(C.SAL_EGR, 0) as SAL_COMP ' +
         '  from ERP_SAL_COMP C ' +
         '  join ERP_DEPOSITOS D on D.ID = C.FK_ERP_DEPOSITOS and  D.INF_DIS_SUC = 1 and D.FK_ERP_SUCURSALES = ' + QuotedStr(ErpSucursalUsuarioActivo);

  SQL := 'insert into ERP_SAL_DISP ' +
         '  (ID, FK_ERP_ARTICULOS, FK_ERP_COLORES, FK_ERP_SUCURSALES, SAL_DISP, EST_EXP_SUC, FEC_ULT_ACT) ' +
         'select ' +
         '  R.ID, ' +
         '  R.FK_ERP_ARTICULOS, ' +
         '  R.FK_ERP_COLORES, ' +
         '  R.FK_ERP_SUCURSALES, ' +
         '  sum(R.SAL_REAL) + sum(R.SAL_COMP) as SAL_DISP, ' +
         '  ''A'' as EST_EXP_SUC, ' +
         '  getdate() as FEC_ULT_ACT ' +
         'from ( ' + Consulta + ') R ' +
         'where R.ID not in (select ID from ERP_SAL_DISP) ' +
         'group by R.ID, R.FK_ERP_SUCURSALES, R.FK_ERP_ARTICULOS, R.FK_ERP_COLORES ' ;

  AdoExecuteCommand(Conn, SQL);

  SQL := 'update ERP_SAL_DISP ' +
         '  set SAL_DISP = isnull(SD.SAL_DISP,0), EST_EXP_SUC = ''A'', FEC_ULT_ACT = getdate() ' +
         'from ERP_SAL_DISP S ' +
         'join ( ' +
         'select R.ID, ' +
         '       sum(R.SAL_REAL) + sum(R.SAL_COMP) as SAL_DISP ' +
         'from ( ' + Consulta + ') R ' +
         'group by R.ID, R.FK_ERP_SUCURSALES, R.FK_ERP_ARTICULOS, R.FK_ERP_COLORES ' +
         ') SD on SD.ID = S.ID ' +
         'where S.SAL_DISP <> isnull(SD.SAL_DISP,0) ' ;

  AdoExecuteCommand(Conn, SQL);
  GrabarLog('Fin generación de saldos disponibles');

end;

Procedure ActualizoCacheClaseITS(TableName:String);
begin
  SQL := 'update ITRIS_LOGCACHED set CLALASTUPDATE = getdate() ' +
         'from ITRIS_LOGCACHED L ' +
         'where L.CLANAME = ' + QuotedStr(TableName);
  ItsExecuteCommand(SQL);
  SQL := 'update ITRIS_LOGCACHED set CLALASTUPDATE = getdate() ' +
         'from ITRIS_LOGCACHED L ' +
         'join ITRIS_ATTRIBUTES A on LOGICTYPE = ''D'' and A.FK_ITRIS_CLASSES = L.CLANAME ' +
         'join ITRIS_CLASSES C on C.CLANAME = L.CLANAME and C.CLASSTYPE = ''P'' ' +
         'where A.MK_ITRIS_CLASSES = ' + QuotedStr(TableName);
  ItsExecuteCommand(SQL);
end;


procedure DistribuirTablas(AdoConn, dsSucursal, FieldName, Frecuencia);
begin
  HoraActual := ItsExecuteFLQuery('select getdate() from ERP_PARAMETROS');
  FecUltActSuc := ItsFlCurValue(dsSucursal,FieldName);
  DesdeFecha := ItsFLAsSqlStr(dsSucursal,FieldName);

// ItsIncDateTime (aDateTime; YearsNo, MonthsNo, DaysNo, HoursNo, MinutesNo, SecondsNo: integer): TDateTime;
  {Actualizo la fecha de ultima actualizacion de la sucursal}
  {Valido hasta que fecha se actualiza dependiendo del metodo}
  if (ItsFlCurValue(dsSucursal,'METODO_ACT') = '1') or
     (ItsFlCurValue(dsSucursal,'METODO_ACT') = '3') then begin
    if ItsFlCurValue(dsSucursal,'METODO_ACT') = '1' then begin
      {Grabo la fecha y hora de la ultima actualizacion mas un dia, pero antes control que no se pase de HoraActual}
      if ItsIncDateTime(FecUltActSuc, 0, 0, 1 , 0, 0 , 0 ) > HoraActual then
        ItsFlWCurValue(dsSucursal, FieldName, ItsIncDateTime(HoraActual, 0, 0, 0 , 0, -1 , 0 ) )
      else
        ItsFlWCurValue(dsSucursal, FieldName, ItsIncDateTime(FecUltActSuc, 0, 0, 1 , 0, 0 , 0 ) );
    end;
    else begin
      {Grabo la fecha y hora de la ultima actualizacion mas fraccion de hora, pero antes control que no se pase de HoraActual}
      Fraccion := ItsFlCurValue(dsSucursal, 'FRACCION');
      if Fraccion = 0 then
        Fraccion := 60;
      if ItsIncDateTime(FecUltActSuc, 0, 0, 0 , 0, Fraccion, 0 ) > HoraActual then
        ItsFlWCurValue(dsSucursal, FieldName, ItsIncDateTime(HoraActual, 0, 0, 0 , 0, -1 , 0 ) )
      else
        ItsFlWCurValue(dsSucursal, FieldName, ItsIncDateTime(FecUltActSuc, 0, 0, 0 , 0,Fraccion , 0 ) );
    end;
  end;
  else
    {Grabo la fecha y hora actual y le resto un minuto}
    ItsFlWCurValue(dsSucursal, FieldName, ItsIncDateTime(HoraActual, 0, 0, 0 , 0, -1 , 0 ) );

  HastaFecha := ItsFLAsSqlStr(dsSucursal,FieldName);

  ItsWriteLn( DesdeFecha);
  ItsWriteLn( HastaFecha);

  Condicion := 'FEC_ULT_ACT between ' + DesdeFecha + ' and ' + HastaFecha ;

  CondiBaja := 'dateadd(mi, datepart(mi,LOGTIME) + 1 , dateadd(hh, datepart(hh,LOGTIME), LOGDATE)) ' +
               'between ' + DesdeFecha + ' and ' + HastaFecha ;

  GrabarLog( 'Condicion: ' + Condicion );
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////                EXPORTACION E IMPORTACION DE CLASES            /////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////  {EXPORTACION DE CLASES DE CASA CENTRAL HACIA LA SUCURSAL} //////////////////

  dsClases := ItsDsOpenQuery('select * from ERP_CLA_SUC ' +
                             'where METODO in (''E'',''A'') and HABILITADO = 1 and FRECUENCIA = ' + QuotedStr(Frecuencia) + ' ' +
                             'order by PRIORIDAD asc' );

  GrabarLog('*********************************************************' );
  GrabarLog('Importacion de registros desde casa central a la sucursal' );
  GrabarLog('*********************************************************' );

  ItsDsFirst(dsClases);
  while not ItsDsEof(dsClases) do begin

    Clase := ItsFlCurValue(dsClases,'ID');
    ActualizaCache := False;

    {Le agrego a la condicion general el filtro de la clase}
    Filtro := ItsFlCurValue(dsClases,'FILTRO') ;
    if Filtro <> '' then
      CondFiltro := Condicion + ' and ( ' + ConvFiltro( Filtro ) + ' )'
    else
      CondFiltro := Condicion ;

    Clave := ItsExecuteFlQuery('select CLAKEYFIELD from ITRIS_CLASSES ' +
                               'where CLANAME = ' + ItsFlAsSqlStr(dsClases,'ID') );

    ItsWriteLn(Clase +'  '+ CondFiltro);

    {Verifico si la clase tiene detalles}
    TieneDetalle := ItsExecuteFlQuery('select count(*) from ITRIS_ATTRIBUTES ' +
                    'where LOGICTYPE = ''D'' and MK_ITRIS_CLASSES = ' + ItsFlAsSqlStr(dsClases,'ID') ) > 0;

    Exportar(AdoConn, Clase, CondFiltro, Clave, CondiBaja, TieneDetalle, ActualizaCache, ItsFlCurValue(dsClases,'METODO') );

    {Actualizo ITRIS_LOGCACHED}
    if ActualizaCache = True then                                           
      ActualizoCacheClaseADO(AdoConn, Clase);

    ItsDsNext(dsClases);
  end;

  GrabarLog('Inicio verificación de tablas');
  {Luego de exportar las clases chequeo y borro inconsistencia en las tablas}
  ItsDsFirst(dsClases);
  while not ItsDsEof(dsClases) do begin

    {Borro las cuentas de tesoreria en el detalle del modelo de tesoreria
    que no esten en el maestro de cuentas de tesoreria}
    if ItsFlCurValue(dsClases,'ID') = 'ERP_MOD_TES' then begin
      AdoExecuteCommand(AdoConn,'delete from ERP_D_MOD_TES ' +
                             'where not FK_ERP_CUE_TES in '+
                             '( select ID from ERP_CUE_TES where FK_ERP_SUCURSALES = '+
                             QuotedStr(ErpSucursalUsuarioActivo) +' OR ISNULL( FK_ERP_SUCURSALES , 0 ) = 0 )');
    end;

    ItsDsNext(dsClases);

  end;
  ItsDsClose(dsClases);
  GrabarLog('Fin verificación de tablas');

end;

procedure CentralizarTablas(AdoConn, Frecuencia);
begin
///////////////  {IMPORTACION DE CLASES DESDE LA SUCURSAL HACIA CASA CENTRAL} //////////////////

  dsClases := ItsDsOpenQuery('select * from ERP_CLA_SUC ' +
                             'where METODO in (''I'',''A'') and HABILITADO = 1 and FRECUENCIA = ' + QuotedStr(Frecuencia) + ' ' +
                             'order by PRIORIDAD asc' );

  GrabarLog('*********************************************************' );
  GrabarLog('Exportacion de registros desde la sucursal a casa central' );
  GrabarLog('*********************************************************' );

  {Borro comprobantes borrados en la sucursal antes de importar}
  {Estos son: ERP_COM_COM / ERP_IMP_VEN / ERP_IMP_COM}
  BorroComprobantes(AdoConn, Frecuencia);

  {Genero tabla ERP_SAL_COMP_SUC antes de importar}
  Habilitado := ItsExecuteFlQuery('select HABILITADO from ERP_CLA_SUC '+
    'where ID = ' + QuotedStr('ERP_SAL_COMP_SUC') + ' and FRECUENCIA = ' + QuotedStr(Frecuencia));
  if Habilitado = True then
    SaldoCompSuc(AdoConn, '1=1');

  {Genero tabla ERP_SAL_DISP antes de importar}
  Habilitado := ItsExecuteFlQuery('select HABILITADO from ERP_CLA_SUC '+
    'where ID = ' + QuotedStr('ERP_SAL_DISP') + ' and FRECUENCIA = ' + QuotedStr(Frecuencia));
  if Habilitado = True then
    SaldoDispSuc(AdoConn, '1=1');

  ItsDsFirst(dsClases);
  while not ItsDsEof(dsClases) do begin

    {Clase a exportar}
    IDClase := ItsFlCurValue(dsClases,'ID');
    ActualizaCache := False;

    {Filtro de la clase}
    Filtro := ItsFlCurValue(dsClases,'FILTRO_IMPORTAR') ;
    if Filtro <> '' then
      Filtro := ConvFiltro( Filtro )
    else
      Filtro := '1=1' ;

    ItsWriteLn( IDClase +'    '+ Filtro );

    Intentos := 1;
    while Intentos <= 3 do begin
      try
        Importar(AdoConn, IDClase, Filtro, ItsFlCurValue(dsClases,'ACT_DAT_IMP'), ActualizaCache, ItsFlCurValue(dsClases,'METODO'));
        Intentos := 100;
      except
        if Intentos = 3 then
          GrabarLog('Error al Exportar: ' + IDClase +'    '+ LastExceptionMessage + '   ' + ItsGetErrorResultText)
        else
          sleep(5000);
        Intentos := Intentos + 1;
      end;
    end;

    {Actualizo ITRIS_LOGCACHED}
    if ActualizaCache = True then
      ActualizoCacheClaseITS( ItsFlCurValue(dsClases,'ID') );

    ItsDsNext(dsClases);
  end;

  ItsDsClose(dsClases);
end;

begin
//  ItsSetUserInteraction(False);
  GrabarLog('Inicio: ' +  'VERSION 11.16 - 26/03/2014');

  {Abro ERP_SUCURSALES}
  GrabarLog('Abro ERP_SUCURSALES ' + ItsVarAsString(ErpSucursalUsuarioActivo) );
  try
    dsSucursal := ItsDsOpenTable( 'ERP_SUCURSALES' , 'ID = ' + QuotedStr( ErpSucursalUsuarioActivo ) ,'' );
    if dsSucursal.RecordCount = 0 then begin
      GrabarLog('  No se pudo abrir ERP_SUCURSALES');
      exit;
    end;
  except
    GrabarLog('  Error al abrir ERP_SUCURSALES ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
    exit;
  end;

  {Chequeo que este definido el Servidor y el Nombre de la Base}
  if (ItsFlEmpty(dsSucursal,'SER_BD') = True) or (ItsFlEmpty(dsSucursal,'NOM_BD') = True )  then begin
    GrabarLog('ERROR: NO ESTA DEFINIDO EL SERVIDOR Y/O LA BASE DE DATOS');
    exit;
  end;

  {Chequeo que la sucursal este habilitada para centralizar}
  if ItsFlCurValue(dsSucursal,'CENTRALIZA') = False  then begin
    GrabarLog('ERROR: LA SUCURSAL NO ESTA HABILITADA PARA CENTRALIZAR DATOS');
    exit;
  end;

  {Chequeo que la hora del SERVIDOR sea mayor a la hora de la ultima conexion}
{
  if ItsFlCurValue(dsSucursal,'FEC_ACT_SUC') > HoraActual then begin
    GrabarLog('ERROR: LA HORA DEL SERVIDOR ES MENOR QUE LA HORA DE LA ULTIMA CONEXION');
    exit;
  end;
}

  {Valido que el usuario sea Auditor}
  Auditor := ItsExecuteFlQuery('select AUDITOR from ITRIS_USERS where ' +
                               'USERNAME like ' + QuotedStr(ActUserName));
  if Auditor = false then begin
    GrabarLog('ERROR: EL USUSARIO DEBE SER AUDITOR');
    exit;
  end;

  {Variables }
  Sucursal   := ItsFlCurValue(dsSucursal,'ID');
  ServidorBD := ItsFlCurValue(dsSucursal,'SER_BD');
  NombreBD   := ItsFlCurValue(dsSucursal,'NOM_BD');

  {Creo conexion a la base local}
  ErrorConexion := False ;
  GrabarLog( 'Conexion ADO' );
  AdoConn := AdoCreateConnection(ServidorBD ,NombreBD, ErrorConexion );
  if ErrorConexion then begin
    GrabarLog( 'Conexión ADO ERROR. Servidor:' + ServidorBD +' Base: '+ NombreBD );
    exit;
  end;

  {Valido la version de ERP}
  Ver_ERP_CasaCentral := ItsExecuteFlQuery('select DBVERSION from ITRIS_PARAMS');
  Ver_ERP_Sucursal := AdoExecuteFlQuery(AdoConn, 'select DBVERSION from ITRIS_PARAMS');
  if Ver_ERP_CasaCentral <> Ver_ERP_Sucursal then begin
    GrabarLog('ERROR DIFIERE VERSION ERP: CASA CENTRAL ' + Ver_ERP_CasaCentral +
                                            ' SUCURSAL ' + Ver_ERP_Sucursal );
    exit;
  end;

  dsParam := ItsDsOpenQuery(
    'select DES_HOR_FRE_A, HAS_HOR_FRE_A, FRE_A, DES_HOR_FRE_M, HAS_HOR_FRE_M, FRE_M, DES_HOR_FRE_B, HAS_HOR_FRE_B, FRE_B from ERP_PARAMETROS');
  HoraActual := ItsExecuteFLQuery('select getdate()');
  H := 0;
  M := 0;
  S := 0;
  D := 0;
  DecodeTime(HoraActual, H, M, S, D);
  HoraActual2 := EnCodeTime(H, M, 0, 0);
  ItsWriteLn(ItsFlCurValue(dsSucursal,'FEC_ULT_ACT_FRE_A'));
  ItsWriteLn(HoraActual2);

  if (HoraActual2 >= ItsFlCurValue(dsParam,'DES_HOR_FRE_A')) and
     (HoraActual2 <= ItsFlCurValue(dsParam,'HAS_HOR_FRE_A')) and
     (ItsFlCurValue(dsSucursal,'FEC_ULT_ACT_FRE_A') + ItsFlCurValue(dsParam,'FRE_A') <= HoraActual) then begin
    GrabarLog('Frecuencia Alta');
    try
      if (HoraActual2 >= '06:00') and (HoraActual2 <= '18:00') then begin
        DistribuirTablas(AdoConn, dsSucursal, 'FEC_ULT_ACT_FRE_A', 'A');
        ItsDsPost(dsSucursal);
      end;
    except
      dsSucursal.Cancel;
      GrabarLog('Error al Distribuir Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
      Raise(LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;

    try
      CentralizarTablas(AdoConn, 'A');
    except
      GrabarLog('Error Centralizar Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;
  end;

  if (HoraActual2 >= ItsFlCurValue(dsParam,'DES_HOR_FRE_M')) and
     (HoraActual2 <= ItsFlCurValue(dsParam,'HAS_HOR_FRE_M')) and
     (ItsFlCurValue(dsSucursal,'FEC_ULT_ACT_FRE_M') + ItsFlCurValue(dsParam,'FRE_M') <= HoraActual) then begin
    GrabarLog('Frecuencia Media');
    try
      if (HoraActual2 >= '06:00') and (HoraActual2 <= '18:00') then begin
        DistribuirTablas(AdoConn, dsSucursal, 'FEC_ULT_ACT_FRE_M', 'M');
        ItsDsPost(dsSucursal);
      end;
    except
      dsSucursal.Cancel;
      GrabarLog('Error al Distribuir Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
      Raise(LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;

    try
      CentralizarTablas(AdoConn, 'M');
    except
      GrabarLog('Error Centralizar Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;

  end;

  if (HoraActual2 >= ItsFlCurValue(dsParam,'DES_HOR_FRE_B')) and
     (HoraActual2 <= ItsFlCurValue(dsParam,'HAS_HOR_FRE_B')) and
     (ItsFlCurValue(dsSucursal,'FEC_ULT_ACT_FRE_B') + ItsFlCurValue(dsParam,'FRE_B') <= HoraActual) then begin
    GrabarLog('Frecuencia Baja');
    try
      if (HoraActual2 >= '06:00') and (HoraActual2 <= '18:00') then begin
        DistribuirTablas(AdoConn, dsSucursal, 'FEC_ULT_ACT_FRE_B', 'B');
        ItsDsPost(dsSucursal);
      end;
    except
      dsSucursal.Cancel;
      GrabarLog('Error al Distribuir Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
      Raise(LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;

    try
      CentralizarTablas(AdoConn, 'B');
    except
      GrabarLog('Error Centralizar Tablas: ' + LastExceptionMessage + '   ' + ItsGetErrorResultText);
    end;
  end;

  {Cierro Sucursales}
  ItsDsClose(dsSucursal);

  {Cierro conexion}
  AdoCloseConnection(AdoConn);

  GrabarLog('Final' + chr(13)+chr(10));

//  ItsSetUserInteraction(True);
end;