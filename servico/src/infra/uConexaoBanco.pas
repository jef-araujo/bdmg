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
    class procedure ConfigurarConexao(AConn: TADOConnection);
  public
    class function GetConnection: TADOConnection;
    class procedure ReleaseConnection(AConn: TADOConnection);
  end;

implementation

uses
  Winapi.ActiveX, uLogger;

class procedure TConexaoBanco.ConfigurarConexao(AConn: TADOConnection);
var
  Config: TConfig;
begin
  TLogger.LogarEmTela('configurando conexão com o banco');

  Config := TConfig.GetInstance;

  AConn.LoginPrompt := False;
  AConn.ConnectionString := Format(
    'Provider=SQLOLEDB.1;' +
    'Server=%s,%d;' +
    'Initial Catalog=%s;',
    [Config.Server, Config.Port, Config.Database]);

  if Config.ConectaPeloWindows then
  begin
    AConn.ConnectionString := AConn.ConnectionString +
      'Integrated Security=SSPI;' +
      'Persist Security Info=False;';
  end
  else
  begin
    AConn.ConnectionString := AConn.ConnectionString +
      Format('User ID=%s;' +
            'Password=%s;' +
            'Persist Security Info=True;',
            [Config.UserName, Config.Password]);
  end;

  AConn.ConnectionString := AConn.ConnectionString +
    // ==================== POOL ====================
    'Pooling=True;' +
    'Max Pool Size=200;' +           // Máximo de conexões simultâneas
    'Min Pool Size=20;' +            // Conexões sempre abertas
    'Connection Lifetime=180;' +    // 3 minutos
    'Load Balance Timeout=60;' +    // Limpeza de ociosas
    'Application Name=BDMG_API;'

end;

class function TConexaoBanco.GetConnection: TADOConnection;
begin
  CoInitialize(nil);
  result := TADOConnection.Create(nil);
  try
    ConfigurarConexao(result);
    TLogger.LogarEmTela('conectando ao banco');
    result.Connected := True;
    TLogger.LogarEmTela('conexão com sucesso ao banco de dados!');
  except
    on e: Exception do
    begin
      TLogger.LogarEmTela('erro ao conectar no banco de dados: ' + e.message);
      raise;
    end;
  end;
end;

class procedure TConexaoBanco.ReleaseConnection(AConn: TADOConnection);
begin
  CoUninitialize;
  FreeAndNil(AConn)
end;

end.
