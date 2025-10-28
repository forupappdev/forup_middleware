unit core.db.connection.intf;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, System.Rtti,
Generics.Collections, forup.util.constants;

type
  IFUPConnection = interface
    ['{4C718D0E-77B7-4B5D-8543-FACB773A180F}']

    function StartTransaction: Boolean;
    function Commit: Boolean;
    function Rollback: Boolean;

    function Execute(const ASQL: string; const AParams: TDictionary<string, TValue> = nil): Integer;
    function Query(const ASQL: string; const AParams: TDictionary<string, TValue> = nil): TDataSet;
    function Activate(const ASQL: string; const AParams: TDictionary<string, TValue> = nil): TDataSet;

    function GetIsInTransaction: Boolean;
    function GetConnectionName: string;

    function getConnType : TConnType;
    procedure setConnType(const aConn : TConnType);

    property ConnType : TConnType read getConnType write setConnType;
  end;

implementation

end.
