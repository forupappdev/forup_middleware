unit forup.constants;

interface
uses System.Classes, System.SysUtils, System.StrUtils, System.Math, System.IOUtils;

const
  CONF_DB_ENV = 'cfg.ini';
  PG_KEY = 'POSTGREDB';
  MONGO_KEY = 'MONGODB';

type
  TDBConstants = class
    public
      class function PGDriver : String;
      class function MongoDriver : String;
      class function MySQLDriver : String;

      class function PG_Admin_Pwd : String;
      class function Mongo_Admin_Pwd : String;
  end;
implementation

{ TDrvPath }

class function TDBConstants.MongoDriver: String;
begin
  Result := TPath.Combine('drv','mongo');
end;

class function TDBConstants.Mongo_Admin_Pwd: String;
begin
  Result := 'n45fg98sd#@!';
end;

class function TDBConstants.MySQLDriver: String;
begin
  Result := TPath.Combine('drv','mysql');
end;

class function TDBConstants.PGDriver: String;
begin
  Result := TPath.Combine('drv','pg');
end;

class function TDBConstants.PG_Admin_Pwd: String;
begin
  Result := 'N45fg98sd#@!';
end;

end.
