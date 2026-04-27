unit uAppconfig;

interface

uses
  System.IniFiles, System.SysUtils, System.Classes;

type
  TAppConfig = class
  private
    FIni: TIniFile;
    class var FInstance: TAppConfig;
    procedure CarregarConfiguracoes;
  public
    IpPortaServicoTarefas: string;

    class function GetInstance: TAppConfig; static;
    constructor Create;
    destructor Destroy; override;    
  end;

implementation

constructor TAppConfig.Create;
begin
  inherited;
  FIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'appconfig.ini');
  CarregarConfiguracoes;
end;

destructor TAppConfig.Destroy;
begin
  FIni.Free;
  FInstance := nil;
  inherited;
end;

class function TAppConfig.GetInstance: TAppConfig;
begin
  if FInstance = nil then
    FInstance := TAppConfig.Create;
  Result := FInstance;
end;

procedure TAppConfig.CarregarConfiguracoes;
begin
  // Banco de Dados
  IpPortaServicoTarefas := FIni.ReadString('', 'IpPortaServicoTarefas', 'http://localhost:9000');
end;

initialization

finalization
  FreeAndNil(TAppConfig.FInstance);

end.
