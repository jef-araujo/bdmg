unit uDadosLogin;

interface

type
  /// <summary>
  /// Armazena as credenciais de login do usuário (Basic Auth)
  /// </summary>
  TDadosLogin = class
  private
    class var FUsername: string;
    class var FPassword: string;
  public
    class property Username: string read FUsername write FUsername;
    class property Password: string read FPassword write FPassword;

    /// <summary>
    /// Retorna se o usuário já está autenticado
    /// </summary>
    class function EstaLogado: Boolean;

    /// <summary>
    /// Limpa as credenciais (usado no logout)
    /// </summary>
    class procedure Limpar;

    /// <summary>
    /// Retorna o header Authorization Basic pronto para usar no REST
    /// </summary>
    class function AuthorizationHeader: string;
  end;

implementation

uses
  System.NetEncoding, System.SysUtils;

class function TDadosLogin.EstaLogado: Boolean;
begin
  Result := (FUsername <> '') and (FPassword <> '');
end;

class procedure TDadosLogin.Limpar;
begin
  FUsername := '';
  FPassword := '';
end;

class function TDadosLogin.AuthorizationHeader: string;
var
  LBase64: string;
begin
  if not EstaLogado then
    Exit('');

  LBase64 := TNetEncoding.Base64.Encode(Username + ':' + Password);
  Result := 'Basic ' + LBase64;
end;

end.