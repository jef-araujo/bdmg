unit uSegurancaMiddleware;

interface

uses
  Horse;

type
  TSegurancaMiddleware = class
  private
    class var FApiKey: string;
  public
    class procedure Configurar(const AApiKey: string);
    class procedure ValidarApiKey(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

uses
  System.SysUtils, System.JSON;

class procedure TSegurancaMiddleware.Configurar(const AApiKey: string);
begin
  FApiKey := AApiKey.Trim;
end;

class procedure TSegurancaMiddleware.ValidarApiKey(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LHeaderKey: string;
  LJson: TJSONObject;
begin
  LHeaderKey := Req.Headers['X-API-Key'].Trim;
  
  if (LHeaderKey.IsEmpty) or (LHeaderKey <> FApiKey) then
  begin
    LJson := TJSONObject.Create;
    try
      LJson.AddPair('success', TJSONFalse.Create);
      LJson.AddPair('message', TJSONString.Create('Chave de API inválida ou não informada.'));
      LJson.AddPair('required_header', TJSONString.Create('X-API-Key'));

      Res
        .Status(401)           // Unauthorized
        .Send(LJson);
    finally
      LJson.Free;
    end;

 //   Exit; 
    raise Exception.Create('Chave de API inválida ou não informada.');
  end;
  
  Next;
end;

end.
