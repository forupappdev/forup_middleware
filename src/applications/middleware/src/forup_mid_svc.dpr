program forup_mid_svc;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.OctetStream,
  Horse.Jhonson,
  Horse.BasicAuthentication,
  Horse.CORS,
  core.sql.attributes in 'sql_core\core.sql.attributes.pas',
  forup.util.functions in 'lib\forup.util.functions.pas',
  forup.util.constants in 'lib\forup.util.constants.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
