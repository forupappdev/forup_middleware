unit forup.log_unit;

interface
uses System.Classes, System.JSON, System.JSON.BSON, System.StrUtils,
System.SysUtils, System.IOUtils, forup.main_connection, forup.constants,
Generics.Collections;

type
  TLogger = class
    public
      class procedure doLog(aToLog : TDictionary<string, string>);
  end;

implementation

{ TLogger }

class procedure TLogger.doLog(aToLog: TDictionary<string, string>);
begin

end;

end.
