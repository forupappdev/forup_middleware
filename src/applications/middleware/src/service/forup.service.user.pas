unit forup.service.user;

interface
uses forup.model.user, forup.util.constants, forup.util.types, forup.util.functions,
core.sql.engine, JSON, JSON.BSON, JSON.Builders, JSON.Types, JSON.Readers, JSON.Writers,
core.db.connection.firedac.base;

type
  TUserService = class(TFUPORM<TUser>)
    private
      _DBConnection : TBaseFireDACConnAdapter;
    public
      constructor Create;

  end;

implementation

{ TUserService }

constructor TUserService.Create;
begin
  _DBConnection := TBaseFireDACConnAdapter.Create('auth_db');

  inherited Create(_DBConnection);
end;

end.
