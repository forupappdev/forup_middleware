unit core.sql.engine;

interface
uses core.sql.builder, core.sql.entity, forup.util.types,
     core.db.connection.intf,

     System.Classes, System.StrUtils, System.Math, System.SysUtils, System.DateUtils,
     System.Generics.Collections, System.Rtti, Data.DB;

type
  TFUPORM<T : class, constructor> = class
   private
    FConn: IFUPConnection;
    _Builder : TSQLBuilder;
   public
    constructor Create(AConn: IFUPConnection);

    function Find(ID: Variant): T; overload; virtual;
    function Find(AObj: T) : TObjectList<T>; overload; virtual;
    function Save(AObj: T): Boolean; virtual;
    function Delete(AObj: T): Boolean; virtual;
    function All: TObjectList<T>; virtual;
  end;

implementation

{ TFUPORM<T> }

uses forup.util.constants;

function TFUPORM<T>.All: TObjectList<T>;
begin
  Result := Self.Find(TDBCriteria.Create);
end;

constructor TFUPORM<T>.Create(AConn: IFUPConnection);
begin
  inherited Create;

  _Builder := TSQLBuilder.Create(AConn.ConnType);
  Self.FConn := AConn;
end;

function TFUPORM<T>.Delete(AObj: T): Boolean;
begin
  Result := True;
end;

function TFUPORM<T>.Find(ID: Variant): T;
var
  aEntity : TBaseEntity;
  pk : TPair<string, string>;
  queryResult : TDataSet;
begin
  try
    aEntity := TBaseEntity.CreateEntity;
    aEntity := aEntity.MorphinCreate<T>;

    _Builder.BaseEntity := aEntity;

    for pk in aEntity.PKColumns do
      begin
        _Builder.BaseEntity.BaseCriteria.Add(TCriterion.Create(pk.Key, '=', ID));
      end;

    queryResult := FConn.Query(
      concat(_Builder.SelectEntity
      , SEPARATOR
      , _Builder.BaseEntity.BaseCriteria.CriteriaBuilt.Text));

    aEntity.ClearEntity;
    aEntity.LoadFromDataSetLine(queryResult);
    Result := aEntity as T;
  finally
    FreeAndNil(queryResult);
  end;
end;

function TFUPORM<T>.Find(AObj: T): TObjectList<T>;
var
  aEntity : TBaseEntity;
  queryCMD : WideString;
  queryResult : TDataSet;
begin
  try
    Result := TObjectList<T>.Create;
    aEntity := TBaseEntity.CreateEntity;
    aEntity := aEntity.MorphinCreate<T>;
    _Builder.BaseEntity := aEntity;

    queryCMD := Concat(_Builder.SelectEntity, SEPARATOR,
    _Builder.BaseEntity.BaseCriteria.CriteriaBuilt.Text);

    queryResult := FConn.Query(queryCMD, nil);

    with queryResult do
      begin
        First;
        while not Eof do
          begin
            aEntity := TBaseEntity.CreateEntity;
            aEntity := aEntity.MorphinCreate<T>;

            aEntity.ClearEntity;
            aEntity.LoadFromDataSetLine(queryResult);
            Result.Add(aEntity as T);

            Next;
          end;
      end;
  finally
    FreeAndNil(aEntity);
    FreeAndNil(queryResult);
  end;
end;

function TFUPORM<T>.Save(AObj: T): Boolean;
var
  aEntity : TBaseEntity;
  queryCMD : WideString;
begin
  try
    aEntity := TBaseEntity.CreateEntity;
    aEntity := aEntity.MorphinCreate<T>;
    aEntity.CloneFrom(TBaseEntity(AObj));
    _Builder.BaseEntity := aEntity;

    if _Builder.BaseEntity.IsPKSet then
      begin
        queryCMD := _Builder.UpdateEntity;
        Result := (FConn.Execute(queryCMD) <> 0);
      end
    else
      begin
        queryCMD := _Builder.InsertEntity;
        with FConn.Activate(queryCMD) do
          begin
            if IsEmpty then
              begin
                Result := False;
              end
            else
              begin
                TBaseEntity(AObj).PKColumns.AddOrSetValue(Fields[0].FieldName,
                Fields[0].AsString);
                Result := True;
              end;
          end;
      end;
  except
    on e : exception do
      begin
        Result := False;
      end;
  end;
end;

end.
