unit forup.helpers;

interface
uses System.JSON.BSON, System.JSON.Builders, System.JSON.Types, system.JSON.Utils,
system.JSON.Readers, system.JSON, System.Classes, System.StrUtils, System.Masks,
system.Math, System.IOUtils, System.SysUtils, Generics.Collections, System.Rtti,
System.Types, System.TypInfo, Data.DB, System.json.Writers, Horse.Jhonson,
FireDAC.Comp.Client;

type
  TJSONHelper = class helper for TJSONValue
    public
      function DictionaryToJSON(aDic : TDictionary<string, string>) : TJSONValue;
      function BuildSQLClause(var aQry : TFDQuery) : Boolean;
  end;
implementation



{ TJSONHelper }

uses forup.log_unit;

function TJSONHelper.BuildSQLClause(var aQry: TFDQuery) : Boolean;
var
  aCriteria : TJSONValue;
begin
  Result := True;
  if Self.TryGetValue<TJSONValue>('criteria', aCriteria) then
    begin

    end
  else Result := False;
end;

function TJSONHelper.DictionaryToJSON(
  aDic: TDictionary<string, string>): TJSONValue;
var
  strWriter  : TStringWriter;
  jsonWriter : TJsonTextWriter;
  aPair : TPair<string, string>;
begin
  strWriter := TStringWriter.Create;
  jsonWriter := TJsonTextWriter.Create(strWriter);
  try
    jsonWriter.Formatting := TJsonFormatting.Indented;
    jsonWriter.WriteStartObject;
    for aPair in aDic do
      begin
        jsonWriter.WritePropertyName(aPair.Key);
        jsonWriter.WriteRaw(aPair.Value);
      end;
    jsonWriter.WriteEndObject;

    Result := TJSONObject.ParseJSONValue(strWriter.ToString);
  except
    on e : exception do
      begin
        TLogger.GetInstance().Log(llFailure, 'dictionary_to_json', 'Fail to build JSON', nil, nil,
        e);
        Result := TJSONObject.ParseJSONValue('{}');
      end;
  end;
end;

end.
