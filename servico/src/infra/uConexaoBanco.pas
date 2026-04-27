unit uConexaoBanco;

interface

uses
  System.SysUtils,
  Data.DB,
  Data.Win.ADODB,
  uConfig;

type
  /// <summary>
  /// Classe de conexão com SQL Server usando ADO (compatível com Community Edition)
  /// </summary>
  TConexaoBanco = class
  private
    FConn: TADOConnection;
    class var FInstance: TConexaoBanco;
    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetInstance: TConexaoBanco; static;
    function GetConnection: TADOConnection;
  end;

implementation

uses
  uLogger;

constructor TConexaoBanco.Create;
begin
  inherited Create;
  FConn := nil;
end;

destructor TConexaoBanco.Destroy;
begin
  if Assigned(FConn) then
    FConn.Free;
  FInstance := nil;
  inherited;
end;

class function TConexaoBanco.GetInstance: TConexaoBanco;
begin
  if FInstance = nil then
    FInstance := TConexaoBanco.Create;
  Result := FInstance;
end;

procedure TConexaoBanco.ConfigurarConexao;
var
  Config: TConfig;
begin
  if not Assigned(FConn) then
  begin
    TLogger.LogarEmTela('configurando conexão com o banco');
    Config := TConfig.GetInstance;
    FConn := TADOConnection.Create(nil);
    FConn.LoginPrompt := False;
    FConn.ConnectionString := Format(
      'Provider=SQLOLEDB.1;' +
      'Server=%s;' +
      'Initial Catalog=%s;',
      [Config.Server, Config.Database]);

    if Config.ConectaPeloWindows then
    begin
      FConn.ConnectionString := FConn.ConnectionString +
        'Integrated Security=SSPI;' +
        'Persist Security Info=False;';
    end
    else
    begin
      FConn.ConnectionString := FConn.ConnectionString +
        Format('User ID=%s;' +
              'Password=%s;' +
              'Persist Security Info=True;',
              [Config.UserName, Config.Password]);
    end;
  end;
end;

function TConexaoBanco.GetConnection: TADOConnection;
begin
  ConfigurarConexao;
  if FConn.Connected = False then
  begin
    TLogger.LogarEmTela('conectando ao banco');
    try
      FConn.Connected := True;
    except
      on e: Exception do
      begin
        TLogger.LogarEmTela('erro ao conectar no banco de dados: ' + e.message);
      end;
    end;
  end;
  Result := FConn;
end;

initialization

finalization
  FreeAndNil(TConexaoBanco.FInstance);

end.