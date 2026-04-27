unit uConfig;

interface

uses
  System.IniFiles, System.SysUtils, System.Classes;

type
  TConfig = class
  private
    FIni: TIniFile;
    class var FInstance: TConfig;
    procedure CarregarConfiguracoes;
  public
    // Configurações do Banco
    Server: string;
    Database: string;
    UserName: string;
    Password: string;
    Port: Integer;
    ConectaPeloWindows: boolean;

    // Configurações da Aplicação
    AppPort: Integer;

    class function GetInstance: TConfig; static;
    constructor Create;
    destructor Destroy; override;

    procedure Salvar; // útil para salvar alterações futuras
  end;

implementation

constructor TConfig.Create;
begin
  inherited;
  FIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  CarregarConfiguracoes;
end;

destructor TConfig.Destroy;
begin
  FIni.Free;
  FInstance := nil;
  inherited;
end;

class function TConfig.GetInstance: TConfig;
begin
  if FInstance = nil then
    FInstance := TConfig.Create;
  Result := FInstance;
end;

procedure TConfig.CarregarConfiguracoes;
begin
  // Banco de Dados
  Server    := FIni.ReadString('Database', 'Server', '(local)\SQLEXPRESS');
  Database  := FIni.ReadString('Database', 'Database', 'BDMG_Tarefas');
  UserName  := FIni.ReadString('Database', 'UserName', 'sa');
  Password  := FIni.ReadString('Database', 'Password', '123456');
  Port      := FIni.ReadInteger('Database', 'Port', 1433);
  ConectaPeloWindows :=  FIni.ReadBool('Database', 'ConectarPeloWindows', false);

  // Aplicação
  AppPort   := FIni.ReadInteger('Application', 'Port', 9000);
end;

procedure TConfig.Salvar;
begin
  FIni.WriteString('Database', 'Server', Server);
  FIni.WriteString('Database', 'Database', Database);
  FIni.WriteString('Database', 'UserName', UserName);
  FIni.WriteString('Database', 'Password', Password);
  FIni.WriteInteger('Database', 'Port', Port);
  FIni.WriteInteger('Application', 'Port', AppPort);  
end;

initialization

finalization
  FreeAndNil(TConfig.FInstance);

end.