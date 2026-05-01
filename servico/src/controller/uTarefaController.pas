unit uTarefaController;

interface

uses
  Horse,
  System.JSON,
  System.SysUtils;

type
  TarefaController = class
  private
    class function PegarJsonDoBody(Req: THorseRequest): TJSONObject;
  public
    // a) Listar todas as tarefas (paginado)
    class procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);

    // b) Incluir nova tarefa
    class procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

    // c) Atualizar status
    class procedure AtualizarStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);

    // d) Excluir tarefa
    class procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);

    // e) Desafio SQL - Estatísticas
    class procedure Estatisticas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  end;

implementation

uses
  System.Math,
  uTarefaRepository,
  uTarefaModel,
  uTarefaFactory;

class procedure TarefaController.Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Page, Limit: Integer;
  Tarefas: TJSONArray;
  Total: Integer;
  Paginacao: TJSONObject;
  TarefaRepo: TTarefaRepository;
begin
  TarefaRepo := TTarefaRepository.Create;
  try
    try
      Page  := StrToIntDef(Req.Query['page'], 1);
      Limit := StrToIntDef(Req.Query['limit'], 20);

      if Page < 1 then Page := 1;
      if Limit < 1 then Limit := 20;
      if Limit > 100 then Limit := 100;

      Tarefas := TarefaRepo.ListarPaginado(Page, Limit, Total);

      Paginacao := TJSONObject.Create;
      try
        Paginacao.AddPair('page', TJSONNumber.Create(Page));
        Paginacao.AddPair('limit', TJSONNumber.Create(Limit));
        Paginacao.AddPair('total', TJSONNumber.Create(Total));
        Paginacao.AddPair('totalPages', TJSONNumber.Create(Ceil(Total / Limit)));
        Paginacao.AddPair('hasNext', TJSONBool.Create(Page * Limit < Total));

        Res.Send(
          TJSONObject.Create
            .AddPair('success', TJSONTrue.Create)
            .AddPair('data', Tarefas)
            .AddPair('pagination', Paginacao)
        ).Status(200);
      except
        Paginacao.Free;
        raise;
      end;

    except
      on E: Exception do
        Res.Send('{"success":false,"message":"Erro ao listar tarefas: ' + E.Message + '"}')
          .Status(500);
    end;
  finally
    FreeAndNil(TarefaRepo);
  end;
end;

class function TarefaController.PegarJsonDoBody(Req: THorseRequest): TJSONObject;
var
  Body: string;
begin
    Body := Req.Body.Trim;

    if Body.IsEmpty then
      raise Exception.Create('Body da requisição vazio');

    // Forma mais compatível entre as versões do Horse
    result := TJSONObject.ParseJSONValue(Body) as TJSONObject;
end;

class procedure TarefaController.Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Tarefa: TTarefaModel;
  Json: TJSONObject;  
  TarefaRepo: TTarefaRepository;
begin
  TarefaRepo := TTarefaRepository.Create;
  try
    try
      Json := PegarJsonDoBody(Req);

      if not Assigned(Json) then
        raise Exception.Create('JSON inválido');

      Tarefa := TTarefaFactory.FromJson(Json);

      TarefaRepo.Incluir(Tarefa);

      Res.Send('{"success":true,"message":"Tarefa incluída com sucesso","id":' + Tarefa.Id.ToString + '}')
        .Status(201);

    except
      on E: Exception do
        Res.Send('{"success":false,"message":"Erro ao incluir tarefa: ' + E.Message + '"}')
          .Status(400);
    end;
  finally
    FreeAndNil(Json);
    FreeAndNil(TarefaRepo);
  end;  
end;

class procedure TarefaController.AtualizarStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
  Status: string;
  Json: TJSONObject;
  TarefaRepo: TTarefaRepository;
begin
  TarefaRepo := TTarefaRepository.Create;
  try
    try
      Id := StrToIntDef(Req.Params['id'], 0);    

      if Id <= 0 then
        raise Exception.Create('ID da tarefa inválido');

      Json := PegarJsonDoBody(Req);
      Status := Json.GetValue<string>('status', '');

      TarefaRepo.AtualizarStatus(Id, Status);

      Res.Send('{"success":true,"message":"Status atualizado com sucesso"}')
        .Status(200);
    except
      on E: Exception do
        Res.Send('{"success":false,"message":"Erro ao atualizar status: ' + E.Message + '"}')
          .Status(400);
    end;
  finally
    FreeAndNil(Json);
    FreeAndNil(TarefaRepo);
  end;  
end;

class procedure TarefaController.Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Id: Integer;
  TarefaRepo: TTarefaRepository;
begin
  TarefaRepo := TTarefaRepository.Create;
  try
    try
      Id := StrToIntDef(Req.Params['id'], 0);

      if Id <= 0 then
        raise Exception.Create('ID da tarefa inválido');

      TarefaRepo.Excluir(Id);

      Res.Send('{"success":true,"message":"Tarefa excluída com sucesso"}')
        .Status(200);
    except
      on E: Exception do
        Res.Send('{"success":false,"message":"Erro ao excluir tarefa: ' + E.Message + '"}')
          .Status(400);
    end;
  finally
    FreeAndNil(TarefaRepo);
  end;
end;

class procedure TarefaController.Estatisticas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  Json: TJSONObject;
  Repo: TTarefaRepository;
begin
  Repo := TTarefaRepository.Create;
  try
    try
      Json := TJSONObject.Create;
      Json.AddPair('total_tarefas', TJSONNumber.Create(Repo.TotalTarefas));
      Json.AddPair('media_prioridade_pendentes', TJSONNumber.Create(Repo.MediaPrioridadePendentes));
      Json.AddPair('tarefas_concluidas_ultimos_7_dias', TJSONNumber.Create(Repo.QuantidadeConcluidasUltimos7Dias));

      Res.Send(Json).Status(200);
    except
      on E: Exception do
        Res.Send('{"success":false,"message":"Erro ao buscar estatísticas: ' + E.Message + '"}')
          .Status(500);
    end;
  finally
    FreeAndNil(Repo);
  end;
end;

end.