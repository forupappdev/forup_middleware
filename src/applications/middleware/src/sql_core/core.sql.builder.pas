unit core.sql.builder;

interface
uses System.SysUtils, System.StrUtils, System.DateUtils, System.JSON, System.JSON.Builders, System.JSON.BSON,
     Generics.Collections, core.sql.entity, core.sql.attributes, System.Math, System.Rtti,
     System.TypInfo, JSON.Types, forup.util.constants, forup.util.functions, System.Classes;

const
  INFO_SELECTCMD = 'SelectCMD';
  INFO_DELETECMD = 'DeleteCMD';
  INFO_UPDATECMD = 'UpdateCMD';
  INFO_INSERTCMD = 'InsertCMD';

type
  {$M+}
  TSQLBuilder = class(TObject)
    private
      _ConnType : TConnType;
      _BaseEntity : TBaseEntity;

      function EntityFound(aCMD : string) : Boolean;

      function getSelectCMD : WideString;
      function getDeleteCMD : WideString;
      function getUpdateCMD : WideString;
      function getInsertCMD : WideString;
    public
      constructor Create(aConnType : TConnType);
    published
      property ConnType : TConnType read _ConnType;
      property BaseEntity : TBaseEntity read _BaseEntity write _BaseEntity;
      property SelectEntity : WideString read getSelectCMD;
      property DeleteEntity : WideString read getDeleteCMD;
      property UpdateEntity : WideString read getUpdateCMD;
      property InsertEntity : WideString read getInsertCMD;

  end;

const
  SELECT_SCOPE = 'SELECT %s FROM %s';
  UPDATE_SCOPE = 'UPDATE %s SET %s';
  INSERT_SCOPE = 'INSERT INTO %s (%s) VALUES (%s)';
  INSERT_SCOPE_SQL = 'INSERT INTO %s (%s) OUTPUT INSERTED.%s VALUES (%s)';
  DELETE_SCOPE = 'DELETE FROM %s';

implementation

{ TSQLBuilder }

uses forup.util.types;

constructor TSQLBuilder.Create(aConnType: TConnType);
begin
  inherited Create;
  Self._ConnType := aConnType;
end;

function TSQLBuilder.EntityFound(aCMD : string): Boolean;
begin
  Result := Assigned(Self._BaseEntity);
  if not Result then
    raise Exception.Create('[BuilderError]['+aCMD+']=Entity not found or nil.');
end;

function TSQLBuilder.getDeleteCMD: WideString;
var
  final_cmd : WideString;
begin
  try
    if EntityFound(INFO_DELETECMD) then
      begin
        final_cmd := Format(DELETE_SCOPE,[
          Self._BaseEntity.TableName
        ]);
        Result := final_cmd;
      end
    else Result := EMPTYSTRING;
  except
    on e : exception do
      begin
        Result := EMPTYSTRING;
        //LogException
      end;
  end;
end;

function TSQLBuilder.getInsertCMD: WideString;
var
  final_cmd : WideString;
  values_insert : string;
  aPK, colVal : TPair<string, string>;
  aPK_name : string;
begin
  try
    if EntityFound(INFO_INSERTCMD) then
      begin
        for aPK in Self._BaseEntity.PKColumns do
          begin
            aPK_name := aPK.Key;
            Break;
          end;

        values_insert := EmptyStr;
        for colVal in Self._BaseEntity.ColumnsValues do
          begin
            if not (Self._BaseEntity.PKColumns.ContainsKey(colVal.Key)) then
              begin
                values_insert := concat(values_insert, colVal.Value, ',');
              end;
          end;

        SetLength(values_insert, Length(values_insert)-1);
        final_cmd := Format(INSERT_SCOPE,[
          Self._BaseEntity.TableName,
          Self._BaseEntity.InsrtFields,
          values_insert
        ]);


        case Self.ConnType of
          ctPostgreSQL, ctFirebird: begin
            final_cmd := final_cmd + ' RETURNING '+aPK_name+';';
          end;
          ctORACLE: begin
             final_cmd := final_cmd + ' RETURNING '+aPK_name+' INTO :lastid;';
          end;
          ctSQLServer: begin
            final_cmd := Format(INSERT_SCOPE_SQL,[
              Self._BaseEntity.TableName,
              Self._BaseEntity.InsrtFields,
              aPK_name,
              values_insert
            ]);
          end;
          ctMySQL: begin
            final_cmd := final_cmd + '; SELECT LAST_INSERT_ID();';
          end;
          ctSQLite: begin
            final_cmd := final_cmd + '; SELECT last_insert_rowid();';
          end
          else final_cmd := final_cmd + ';';
        end;
        //Result := ;
      end
    else Result := EMPTYSTRING;
  except
    on e : exception do
      begin
        Result := EMPTYSTRING;
        //LogException
      end;
  end;

end;

function TSQLBuilder.getSelectCMD: WideString;
var
  final_cmd : WideString;
begin

  try
    if EntityFound(INFO_SELECTCMD) then
      begin
        final_cmd := Format(SELECT_SCOPE,[
          Self._BaseEntity.AllColumns,
          Self._BaseEntity.TableName
        ]);
        Result := final_cmd;
      end
    else Result := EMPTYSTRING;
  except
    on e : exception do
      begin
        Result := EMPTYSTRING;
        //LogException
      end;
  end;
end;

function TSQLBuilder.getUpdateCMD: WideString;
var
  aColValues : TPair<String, String>;
  aPKs : TDictionary<String, String>;
  final_cmd : WideString;
  update_body : TStringList;
  crit : TDBCriteria;
begin
  try
    if EntityFound(INFO_UPDATECMD) then
      begin
        aPKs := Self._BaseEntity.PKColumns;
        crit := TDBCriteria.Create();

        for aColValues in aPKs do
          begin
            crit.Add(TCriterion.Create(aColValues.Key, '=', aColValues.Value));
          end;

        update_body := TStringList.Create;
        update_body.Clear;
        for aColValues in Self._BaseEntity.ColumnsValues do
          begin
            if not aPKs.ContainsKey(aColValues.Key) then
              update_body.Add(concat(aColValues.Key,' = ',aColValues.Value, ','));
          end;

        update_body.Strings[update_body.Count-1] :=
          Copy(update_body.Strings[update_body.Count-1], 1, Length(update_body.Strings[update_body.Count-1])-2);

        final_cmd := concat(Format(
          UPDATE_SCOPE,
          [Self._BaseEntity.TableName,
          update_body.Text]
        ),' ',crit.CriteriaBuilt.Text,';');

        Result := final_cmd;
      end
    else Result := EMPTYSTRING;
  except
     on e : exception do
      begin
        Result := EMPTYSTRING;
        //LogException
      end;
  end;
end;

end.
