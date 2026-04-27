unit uTratamentoStatusCodeHttp;

interface

uses
  System.SysUtils,
  RESTRequest4D;

type
  TTratamentoStatusCodeHttp = class
  public
    class procedure Executar(AResponse: IResponse; const AOperacao: string);
  end;

implementation

uses
  uExceptionsCliente;

{ TTratamentoStatusCodeHttp }

class procedure TTratamentoStatusCodeHttp.Executar(AResponse: IResponse; const AOperacao: string);
begin
  case AResponse.StatusCode of
    200, 201, 204:
      Exit; // sucesso

    400:
      raise Exception.Create('Dados inválidos. Verifique as informações enviadas.');

    401:
     raise ENaoAutenticadoException.Create('Usuário ou senha inválidos. Faça login novamente.');

    403:
     raise Exception.Create('Acesso negado. Você não tem permissão para esta ação.');

    404:
      raise Exception.Create('Recurso não encontrado.');

    500:
      raise Exception.Create('Erro interno no servidor. Tente novamente mais tarde.');

   else
    raise Exception.CreateFmt('Erro ao %s. Status: %d', [AOperacao, AResponse.StatusCode]);
 end;
end;

end.
