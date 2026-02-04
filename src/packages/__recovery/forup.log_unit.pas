unit forup.log_unit;

interface
uses System.Classes, System.JSON, System.JSON.BSON, System.StrUtils,
System.SysUtils, System.IOUtils, forup.main_connection, forup.constants,
Generics.Collections, System.Math, System.DateUtils;

type
  TLogger = class
    public
      class procedure doLogLocal(aToLog : TDictionary<string, string>);
      class procedure doLog(aToLog : TDictionary<string, string>);
  end;

implementation

{ TLogger }

class procedure TLogger.doLog(aToLog: TDictionary<string, string>);
begin

end;

class procedure TLogger.doLogLocal(aToLog: TDictionary<string, string>);
var
  localdir : string;
  localFile : string;

  logFile : TextFile;
begin
  localFile := 'fup_entity_service.log';
  localdir := TPath.Combine([
      TDirectory.GetCurrentDirectory,
      'log'
      ]);
  if not TDirectory.Exists(localdir) then
    TDirectory.CreateDirectory(localdir);

  logFile



end;

end.
