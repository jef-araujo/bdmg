unit uTarefaService;

interface

uses
  RESTRequest4D,
  System.JSON,
  System.SysUtils,
  uDadosLogin,
  uTarefaModel;

type
  TTarefaService = class
  public
    function ListarTarefas(APage: Integer = 1; ALimit: Integer = 20): TJSONArray;
    function IncluirTarefa(ATarefa: TTarefaModel): Boolean;
    function AtualizarStatus(AId: Integer; AStatus: string): Boolean;
    function ExcluirTarefa(AId: Integer): Boolean;
    function ObterEstatisticas: TJSONObject;
  end;

implementation

uses
  uTratamentoStatusCodeHttp, uAppConfig;

function TTarefaService.ListarTarefas(APage: Integer = 1; ALimit: Integer = 20): TJSONArray;
var
  Response: IResponse;  
  JsonValue: TJSONValue;
  JsonObj: TJSONObject;
begin
  Result := nil;

  try
    Response := TRequest.New
      .BasicAuthentication(TDadosLogin.Username, TDadosLogin.Password)
      .BaseURL(TAppConfig.GetInstance.IpPortaServicoTarefas)
      .Resource('tarefas')
      .AddParam('page', APage.ToString)
      .AddParam('limit', ALimit.ToString)
      .Get;

    TTratamentoStatusCodeHttp.Executar(Response, 'listar tarefas');

    if Response.Content.Trim.IsEmpty then
      Exit;

    JsonValue := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Response.Content), 0, True);
    try
      if JsonValue is TJSONArray then
        Result := TJSONArray(JsonValue.Clone)
      else if JsonValue is TJSONObject then
        Result := TJSONObject(JsonValue).GetValue<TJSONArray>('data').Clone as TJSONArray;
    finally
      JsonValue.Free;
    end;
  finally
    Response := nil;
  end;
end;

function TTarefaService.IncluirTarefa(ATarefa: TTarefaModel): Boolean;
var
  Response: IResponse;
  Json: TJSONObject;
begin
  Json := ATarefa.ToJson;
  try
    Response := TRequest.New
      .BasicAuthentication(TDadosLogin.Username, TDadosLogin.Password)
      .BaseURL(TAppConfig.GetInstance.IpPortaServicoTarefas)
      .Resource('tarefas')
      .AddBody(Json.ToString).Post;

    TTratamentoStatusCodeHttp.Executar(Response, 'incluir tarefa');

    Result := Response.StatusCode in [200, 201];
  finally
    Json.Free;
    Response := nil;
  end;
end;

function TTarefaService.AtualizarStatus(AId: Integer; AStatus: string): Boolean;
var  
  Response: IResponse;
  Json: TJSONObject;
begin
  Json := TJSONObject.Create;
  try
    Json.AddPair('status', TJSONString.Create(AStatus));

    Response := TRequest.New
      .BasicAuthentication(TDadosLogin.Username, TDadosLogin.Password)
      .BaseURL(TAppConfig.GetInstance.IpPortaServicoTarefas)
      .Resource(Format('tarefas/%d/status', [AId]))
      .AddBody(Json.ToString).Put;

    TTratamentoStatusCodeHttp.Executar(Response, 'atualizar status da tarefa');

    Result := Response.StatusCode = 200;
  finally
    Json.Free;
    Response := nil;
  end;
end;

function TTarefaService.ExcluirTarefa(AId: Integer): Boolean;
var
  Request: IRequest;
  Response: IResponse;
begin
  try
    Response := TRequest.New
      .BasicAuthentication(TDadosLogin.Username, TDadosLogin.Password)
      .BaseURL(TAppConfig.GetInstance.IpPortaServicoTarefas)
      .Resource(Format('tarefas/%d', [AId]))
      .Delete;

    TTratamentoStatusCodeHttp.Executar(Response, 'excluir tarefa');

    Result := Response.StatusCode in [200, 204];
  finally
    Response := nil;
  end;  
end;

function TTarefaService.ObterEstatisticas: TJSONObject;
var
  Response: IResponse;
  JsonValue: TJSONValue;
begin
  Result := nil;
  try
    Response := TRequest.New
      .BasicAuthentication(TDadosLogin.Username, TDadosLogin.Password)
      .BaseURL(TAppConfig.GetInstance.IpPortaServicoTarefas)
      .Resource('estatisticas')
      .Accept('application/json')
      .Get;

    TTratamentoStatusCodeHttp.Executar(Response, 'obter estatísticas');

    if Response.Content.Trim.IsEmpty then
      Exit;


    JsonValue := TJSONObject.ParseJSONValue(Response.Content, True); // True = parsing estrito

    if JsonValue is TJSONObject then
      Result := TJSONObject(JsonValue)
    else
    begin
      if Assigned(JsonValue) then
        JsonValue.Free;
    end;

  finally
    Response := nil;
  end;
end;

end.