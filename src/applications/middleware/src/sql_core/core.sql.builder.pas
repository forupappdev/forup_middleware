unit core.sql.builder;

interface
uses System.SysUtils, System.StrUtils, System.DateUtils, System.JSON, System.JSON.Builders, System.JSON.BSON,
     Generics.Collections, core.sql.entity, core.sql.attributes, System.Math, System.Rtti,
     System.TypInfo, JSON.Types, forup.util.constants, forup.util.functions;

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

  end;

const
  SELECT_SCOPE = 'SELECT %s FROM %s';
  UPDATE_SCOPE = 'UPDATE %s SET %s';
  INSERT_SCOPE = 'INSERT INTO %s (%s) VALUES (%s)';
  DELETE_SCOPE = 'DELETE FROM %s';

implementation

{ TSQLBuilder }

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
begin
  try
    if EntityFound(INFO_INSERTCMD) then
      begin
        final_cmd := Format(INSERT_SCOPE,[
          Self._BaseEntity.TableName,
          Self._BaseEntity.
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
begin

end;

end.
